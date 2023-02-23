//
//  StoreProductViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import UIKit

class StoreProductViewController: UIViewController {
    var desserts: [Dessert] = []

    @IBOutlet weak var storeProductCV: UICollectionView!{
        didSet{
            storeProductCV.delegate = self
            storeProductCV.dataSource = self
            
            // MARK: Xib파일이 없는 상태로 등록하려고 하자 오류가 나서 임시로 주석처리 해둠
//            let cellNib = UINib(nibName: "StoreImageCell", bundle: nil)
//            storeProductCV.register(cellNib, forCellWithReuseIdentifier: "StoreImageCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(desserts: [Dessert]) {
        self.desserts = desserts
        storeProductCV?.reloadData()
    }
}

extension StoreProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return desserts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreImageCell", for: indexPath) as? StoreImageCell else { return UICollectionViewCell() }
        
        let url = desserts[indexPath.row].dessertImgUrl
        cell.storeImageView.kf.setImage(with: URL(string: url))
        return cell
    }
}

extension StoreProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 20) / 3 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
}
