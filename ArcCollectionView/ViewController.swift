//
//  ViewController.swift
//  ArcCollectionView
//
//  Created by Alex Miculescu on 11/05/2018.
//  Copyright © 2018 alexmicu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var arcCollectionView: ArcCollectionView!
    override func viewDidLoad() {
        
        super.viewDidLoad()

        arcCollectionView.dataSource = self
        arcCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        arcCollectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

