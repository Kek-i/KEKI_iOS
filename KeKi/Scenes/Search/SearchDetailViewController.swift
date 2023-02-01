//
//  SearchDetailViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class SearchDetailViewController: UIViewController {
    
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectMenu: UIMenu!
    
    @IBOutlet weak var resultCV: UICollectionView! {
        didSet{
            resultCV.delegate = self
            resultCV.dataSource = self
            
            let searchDetailCellNib = UINib(nibName: "SearchDetailCell", bundle: nil)
            resultCV.register(searchDetailCellNib, forCellWithReuseIdentifier: "SearchDetailCell")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
 
extension SearchDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchDetailCell", for: indexPath)
        
        return cell
    }
}

extension SearchDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 19)
    }
}
