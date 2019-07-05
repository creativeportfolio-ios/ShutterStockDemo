//
//  ImageCollectionViewCell.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2019 Nishant. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var displayImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        displayImageView.layer.cornerRadius = 6
        displayImageView.clipsToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.7
    }
    
    func configuration(_ imageData: PhotosDetails) {
        if let imgUrl = try? imageData.assets?.preview_1000?.url?.asURL() {
            displayImageView.sd_setImage(with: imgUrl, placeholderImage: UIImage(named: "ic_loading_icon"))
        }
        else {
            displayImageView.image = UIImage(named: "ic_loading_icon")
        }
    }

}
