//
//  SearchImageViewController.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import UIKit
import BrightFutures
import DKPhotoGallery
class SearchImageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var presenter = SearchImagePresenter(repository: SearchImageRepository(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Images"
        
        self.fetchImage(withPage: 1)
        
        if let patternImage = UIImage(named: "Pattern") {
            view.backgroundColor = UIColor(patternImage: patternImage)
        }
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 5, bottom: 5, right: 5)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.cellPadding = 5
            layout.numberOfColumns = 2
        }
        
        searchBar.placeholder = "Search Images"
        searchBar.delegate = self
    }
    
    func fetchImage(withPage page: Int? = nil, query: String? = nil) {
        let isConnected = ReachabilityManager.shared.isConnected
        guard isConnected else {
            let alert = UIAlertController(title: "Error!", message: "No internet connect", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        presenter.fetchImage(withPage: page, query: query)
    }
}

extension SearchImageViewController: SearchImageDelegate {
    func finishWithError(_ error: String?) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func finishWithSuccess() {
        self.collectionView.reloadData()
    }
}

extension SearchImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == presenter.imageArray.count - 5 {
            fetchImage()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.configuration(presenter.imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell else {
            return
        }
        
        let gallery = DKPhotoGallery()
        gallery.singleTapMode = .dismiss
        gallery.items = presenter.imageArray.compactMap {
            if let url = try? $0.assets?.preview_1000?.url?.asURL() {
                return DKPhotoGalleryItem(imageURL: url)
            }
            return nil
        }
        gallery.presentingFromImageView = cell.displayImageView
        gallery.presentationIndex = indexPath.item
        
        gallery.finishedBlock = { dismissIndex, dismissItem in
            let index = IndexPath(item: dismissIndex, section: 0)
            guard let cell = collectionView.cellForItem(at: index) as? ImageCollectionViewCell else {
                return nil
            }
            return cell.displayImageView
        }
        
        self.present(photoGallery: gallery)
    }
}

extension SearchImageViewController: PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return (presenter.imageArray[indexPath.item].assets?.preview?.height(forWidth: withWidth) ?? 0)
    }
    
    func collectionView(collectionView: UICollectionView,
                               heightForAnnotationAtIndexPath indexPath: IndexPath,
                               withWidth: CGFloat) -> CGFloat {
        return 0
    }
}

extension SearchImageViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.endEditing(true)
        searchBar.setShowsCancelButton(false, animated: true)
        fetchImage(withPage: 1)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchImage(withPage: 1, query: searchBar.text ?? "")
        searchBar.endEditing(true)
    }
}
