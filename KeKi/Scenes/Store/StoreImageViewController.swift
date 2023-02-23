//
//  StoreImageViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import UIKit

class StoreImageViewController: UIViewController {
    var feeds: [Feed] = []
    
    @IBOutlet weak var storeImageCV: UICollectionView! {
        didSet{
            storeImageCV.delegate = self
            storeImageCV.dataSource = self
            
            // MARK: Xib파일이 없는 상태로 등록하려고 하자 오류가 나서 임시로 주석처리 해둠
//            let cellNib = UINib(nibName: "StoreImageCell", bundle: nil)
//            storeImageCV.register(cellNib, forCellWithReuseIdentifier: "StoreImageCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(feeds: [Feed]) {
        self.feeds = feeds
        storeImageCV.reloadData()
    }
}


extension StoreImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreImageCell", for: indexPath) as? StoreImageCell else { return UICollectionViewCell() }
        
        let url = feeds[indexPath.row].postImgUrls[0]
        cell.storeImageView.kf.setImage(with: URL(string: url))
        return cell
    }
}

extension StoreImageViewController: UICollectionViewDelegateFlowLayout {
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
