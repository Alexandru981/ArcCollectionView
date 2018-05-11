//
//  Matrix3By3.swift
//  TestCircleCollectionView
//
//  Created by Alex Miculescu on 30/04/2018.
//  Copyright © 2018 Minds For Life. All rights reserved.
//

struct Matrix3By3<T: Numeric> {
    private let values: [[T]]
    
    init?(_ values: [[T]]) {
        
        guard values.count == 3 else { return nil }
        for line in values {
            guard line.count == 3 else { return nil }
        }
        
        self.values = values
    }
    
    subscript(_ line: Int, _ col: Int) -> T {
        return values[line][col]
    }
    
    func det() -> T {
        
        let firstPlus  = self[0, 0] * self[1, 1] * self[2, 2]
        let secondPlus = self[1, 0] * self[2, 1] * self[0, 2]
        let thirdPlus  = self[0, 1] * self[1, 2] * self[2, 0]
        
        let firstMinus  = self[2, 0] * self[1, 1] * self[0, 2]
        let secondMinus = self[1, 0] * self[0, 1] * self[2, 2]
        let thirdMinus  = self[0, 0] * self[2, 1] * self[1, 2]
        
        let plus  = firstPlus + secondPlus + thirdPlus
        let minus = firstMinus + secondMinus + thirdMinus
        
        return plus - minus
    }
}
