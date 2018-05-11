//
//  ArcCollectionView.swift
//
//  Created by Alex Miculescu on 11/05/2018.
//

import UIKit

class ArcCollectionView: UICollectionView {

    var arcColor = UIColor.black { didSet { self.setNeedsDisplay() } }
    var itemSize = CGSize(width: 100, height: 100) { didSet { arcLayout?.itemSize = itemSize } }
    
    var leftPointPercentage = CGFloat(0.75)
    var rightPointPercentage = CGFloat(0.45)
    
    fileprivate var arcCenter: CGPoint?
    fileprivate var arcRadius: CGFloat?
    fileprivate var oldBoundsSize = CGSize.zero
    fileprivate var arcLayout : CollectionViewArcLayout? {
        return self.collectionViewLayout as? CollectionViewArcLayout
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    func initialize() {
        let arcLayout = CollectionViewArcLayout()
        arcLayout.itemSize = self.itemSize
        self.collectionViewLayout = arcLayout
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if hasBoundsSizeUpdate {
            calculateArc()
            setNeedsDisplay()
            updateLayout()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        defer { super.draw(rect) }
        
        guard let center = arcCenter, let radius = arcRadius else { return }
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: .pi, endAngle: .pi /  2, clockwise: true)
        path.addLine(to: center)
        path.addLine(to: CGPoint(x: radius - rect.width, y: center.y))
        self.arcColor.setFill()
        path.fill()
    }
}

private extension ArcCollectionView {
    
    func calculateArc() {
        let leftPoint = CGPoint(x: 0.0, y: self.bounds.height * leftPointPercentage)
        let centerPoint = CGPoint(x: self.bounds.width / 2,
                                  y: self.bounds.height / 2)
        let rightPoint = CGPoint(x: self.bounds.width,
                                 y: self.bounds.height * rightPointPercentage)
        
        self.arcCenter = [leftPoint, centerPoint, rightPoint].center()
        self.arcRadius = arcCenter?.distance(to: centerPoint)
    }
    
    var hasBoundsSizeUpdate: Bool {
        if oldBoundsSize != self.bounds.size {
            oldBoundsSize = self.bounds.size
            return true
        }
        
        return false
    }
    
    func updateLayout() {
        arcLayout?.arcCenter = self.arcCenter
        arcLayout?.arcRadius = self.arcRadius
        arcLayout?.invalidateLayout()
    }
}
