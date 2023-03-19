//
//  HomeCollectionViewCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imgContainerView: UIView!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
   
    func setupLayout() {
        storeImageView.layer.masksToBounds = true
        storeImageView.layer.cornerRadius = 12
        
        imgContainerView.layer.borderWidth = 0
        imgContainerView.layer.borderColor = UIColor.white.cgColor
        imgContainerView.layer.cornerRadius = 12

        imgContainerView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        imgContainerView.layer.shadowRadius = 4
        imgContainerView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imgContainerView.layer.shadowOpacity = 0.7
    }
    
    func setData(storeData: HomePostRes) {
        print("img url - \(storeData.postImgUrl)")
        if storeData.postImgUrl.contains("https:") {
            // https:...형태의 Url
            storeImageView.kf.setImage(with: URL(string: storeData.postImgUrl))
        } else {
            // 디렉토리 형태의 Url
            let _ = FirebaseStorageManager.downloadImage(urlString: storeData.postImgUrl, completion: { [weak self] img in
                self?.storeImageView.image = img
            })
        }
        
        storeNameLabel.text = storeData.storeTitle
    }
}
