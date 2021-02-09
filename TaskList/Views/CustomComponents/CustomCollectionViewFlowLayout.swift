//
//  CustomCollectionViewFlowLayout.swift
//  TaskList
//
//  Created by Admin on 2021/02/09.
//

import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attribute?.transform = CGAffineTransform(scaleX: 0, y: 0)
        return attribute
    }
}
