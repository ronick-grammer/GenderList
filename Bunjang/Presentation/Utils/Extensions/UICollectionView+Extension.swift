//
//  UICollectionView+Extension.swift
//  Bunjang
//
//  Created by Ronick on 6/22/23.
//

import UIKit

extension UICollectionView {
    var visibleIndexPath: IndexPath? {
        let visibleRect = CGRect(origin: contentOffset, size: bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = indexPathForItem(at: visiblePoint)
        
        return visibleIndexPath
    }
}
