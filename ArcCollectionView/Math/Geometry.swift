//
//  Geometry.swift
//  TestCircleCollectionView
//
//  Created by Alex Miculescu on 11/05/2018.
//  Copyright © 2018 Minds For Life. All rights reserved.
//

import UIKit

extension Collection where Element == CGPoint {
    
    /**
     *  Calculates the center of the circle described by the three points.
     *  If the points are in a line nil will be returned.
     */
    func center() -> CGPoint? {
        guard self.count == 3 else {
            assertionFailure("Only knows to calculate the center of 3 points");
            return nil
        }
        
        var a = CGPoint.zero
        var b = CGPoint.zero
        var c = CGPoint.zero
        var i = 0
        
        for point in self {
            switch i {
            case 0: a = point
            case 1: b = point
            case 2: c = point
            default: break
            }
            
            i += 1
        }
        
        let denominatorMatrix = Matrix3By3<CGFloat>([
            [a.x, a.y, 1],
            [b.x, b.y, 1],
            [c.x, c.y, 1]
            ])!
        
        let denominator = denominatorMatrix.det()
        
        guard denominator != 0.0 else { return nil }
        
        let xMatrix = Matrix3By3<CGFloat>([
            [pow(a.x, 2) + pow(a.y, 2), a.y, 1],
            [pow(b.x, 2) + pow(b.y, 2), b.y, 1],
            [pow(c.x, 2) + pow(c.y, 2), c.y, 1]
            ])!
        
        let yMatrix = Matrix3By3<CGFloat>([
            [a.x, pow(a.x, 2) + pow(a.y, 2), 1],
            [b.x, pow(b.x, 2) + pow(b.y, 2), 1],
            [c.x, pow(c.x, 2) + pow(c.y, 2), 1]
            ])!
        
        
        let xNumerator = xMatrix.det()
        let yNumerator = yMatrix.det()
        
        return CGPoint(x: xNumerator / (2 * denominator), y: yNumerator / (2 * denominator))
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}
