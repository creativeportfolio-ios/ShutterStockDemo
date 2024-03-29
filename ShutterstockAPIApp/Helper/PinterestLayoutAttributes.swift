//
//  PinterestLayoutAttributes.swift
//  ShutterstockAPIApp
//
//  Created by Nishant on 05/07/19.
//  Copyright © 2017 Nishant. All rights reserved.
//

import UIKit


/**
 CollectionViewLayoutAttributes.
 */
public class PinterestLayoutAttributes: UICollectionViewLayoutAttributes {
    /**
     Image height to be set to contstraint in collection view cell.
     */
    public var imageHeight: CGFloat = 0
    
    override public func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }
    
    override public func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}
