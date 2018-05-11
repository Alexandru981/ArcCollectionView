//
//  CollectionViewArcLayout.swift
//
//  Created by Alex Miculescu on 30/04/2018.
//

import UIKit

class CollectionViewArcLayout: UICollectionViewFlowLayout {
    
    var arcCenter: CGPoint?
    var arcRadius: CGFloat?
    var maxScale = CGFloat(2.0)
    var minScale = CGFloat(0.5)
    
    fileprivate var attributesCash = [UICollectionViewLayoutAttributes]()
    fileprivate var oldBounds = CGRect.zero
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var arr = [UICollectionViewLayoutAttributes]()
        
        for attributes in attributesCash {
            if attributes.frame.intersects(rect) {
                arr.append(attributes)
            }
        }
        
        return arr
    }
    
    override func prepare() {
        super.prepare()
        
        attributesCash = [UICollectionViewLayoutAttributes]()
        guard let itemsCount = collectionView?.numberOfItems(inSection: 0) else { return }
        for index in 0 ..< itemsCount {
            guard let attributes = layoutAttributesForItem(at: index) else {
                attributesCash = [UICollectionViewLayoutAttributes]()
                return
            }
            
            attributesCash.append(attributes)
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return .zero }
        
        let index = self.index(for: proposedContentOffset.x)
        return CGPoint(x: CGFloat(index) * collectionView.bounds.width / 2, y: proposedContentOffset.y)
    }
    
    override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return CGSize.zero }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        let width = CGFloat(1 + itemsCount) * collectionView.bounds.width / 2
        
        return CGSize(width: width, height: collectionView.bounds.height)
    }
}

//MARK: - Helper
private extension CollectionViewArcLayout {
    
    func y(for x: CGFloat) -> CGFloat? {
        guard let center = arcCenter else { return nil }
        guard let radius = arcRadius else { return nil }
        
        let squaredValue = pow(radius, 2) - pow((x - center.x), 2)
        guard squaredValue >= 0.0 else { return nil }
        let y = sqrt(squaredValue) + center.y
        let d = y - center.y
        return y - 2 * d
    }
    
    func layoutAttributesForItem(at index: Int) -> UICollectionViewLayoutAttributes? {
        
        guard let collectionView = collectionView else { return nil }
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
        
        let xForItem = CGFloat(1 + index) * collectionView.bounds.width / 2
        let xMappedToOrigin = -(collectionView.contentOffset.x - xForItem)
        let yForItem = y(for: xMappedToOrigin) ?? 0.0
        
        let scaleFactor = self.scaleFactor(for: xForItem)
        
        var frame = CGRect()
        frame.size.width = itemSize.width * scaleFactor
        frame.size.height = itemSize.height * scaleFactor
        frame.origin.x = xForItem - frame.size.width / 2
        frame.origin.y = yForItem - frame.size.height / 2
        
        attributes.frame = frame
        
        return attributes
    }
    
    func index(for offset: CGFloat) -> Int {
        guard let collectionView = collectionView else { return 0 }
        return Int(round(offset / (collectionView.bounds.width / 2)))
    }

    func scaleFactor(for x: CGFloat) -> CGFloat {
        guard let collectionView = self.collectionView else { return 1.0 }
        
        var cappedX = abs(x - (collectionView.contentOffset.x + collectionView.bounds.width / 2)) / (collectionView.bounds.width / 2)
        cappedX = max(0.0, min(1.0,  cappedX))
        let scaleFactor = maxScale - cappedX * (maxScale - minScale)
        
        return scaleFactor
    }
}
