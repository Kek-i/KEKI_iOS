//
//  StoreProductViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import UIKit

class StoreProductViewController: UIViewController {

    @IBOutlet weak var storeProductCV: UICollectionView!{
        didSet{
            storeProductCV.delegate = self
            storeProductCV.dataSource = self
            
            let cellNib = UINib(nibName: "StoreImageCell", bundle: nil)
            
            storeProductCV.register(cellNib, forCellWithReuseIdentifier: "StoreImageCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }

}

extension StoreProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreImageCell", for: indexPath)
        
        return cell
    }
    
    
}
