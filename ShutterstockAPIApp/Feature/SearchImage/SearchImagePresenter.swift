//
//  SearchImagePresenter.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import Foundation
class SearchImagePresenter {
    var repository: SearchImageRepository?
    private weak var delegate: SearchImageDelegate?
    var imageArray: [PhotosDetails] = []
    
    private var isApiInRuning: Bool = false
    private var isApiFailer: Bool = false
    private var page: Int = 1
    
    init(repository: SearchImageRepository, delegate: SearchImageDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    func fetchImage(withPage page: Int? = nil, query: String? = nil) {
        
        if page == 1 {
            imageArray.removeAll()
            self.page = 1
            isApiFailer = false
            isApiInRuning = false
        }
        
        if isApiFailer || isApiInRuning { return }
        if page == 0 && imageArray.count != 0 { return }
        isApiInRuning = true
        
        repository?.getSearchImages(self.page, query: query ?? "") { [weak self] (error, response) in
            if let searchImage = response {
                if self?.page == 1 {
                    self?.imageArray = searchImage.data ?? []
                }
                else {
                    self?.imageArray.append(contentsOf: searchImage.data ?? [])
                }
                self?.page += 1
                self?.delegate?.finishWithSuccess()
            }
            else {
                if let error = error {
                    self?.delegate?.finishWithError(error.localizedDescription)
                }
                self?.isApiFailer = true
            }
            self?.isApiInRuning = false
        }
    }
}
