//
//  ColumnLayout.swift
//  FinancialHouse
//
//  Created by Olgu on 17.10.2020.
//

import UIKit

final class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    private let minColumnWidth: CGFloat = 250.0
    private let cellHeight: CGFloat = 200.0
    
    // MARK: Layout Overrides
    
    /// - Tag: ColumnFlowExample
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let availableWidth = collectionView.bounds.inset(by: collectionView.layoutMargins).width
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        self.itemSize = CGSize(width: cellWidth, height: cellHeight)
        self.sectionInset = UIEdgeInsets(top: self.minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        if #available(iOS 11.0, *) {
            self.sectionInsetReference = .fromSafeArea
        } else {
            // Fallback on earlier versions
        }
    }
    
//    private var focusedIndexPath: IndexPath?
//    
//    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
//        super.prepare(forAnimatedBoundsChange: oldBounds)
//        focusedIndexPath = collectionView?.indexPathsForVisibleItems.first
//    }
//    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        focusedIndexPath = collectionView?.indexPathsForVisibleItems.first
//        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//    }
//    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
//        guard let indexPath = focusedIndexPath,
//              let attributes = layoutAttributesForItem(at: indexPath),
//              let collectionView = collectionView else {
//            
//            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
//        }
//        
//        return CGPoint(x: attributes.frame.origin.x - collectionView.contentInset.left,
//                       y: attributes.frame.origin.y - collectionView.contentInset.top)
//    }
//        
//    override func finalizeAnimatedBoundsChange() {
//        super.finalizeAnimatedBoundsChange()
//        focusedIndexPath = nil
//    }
}
