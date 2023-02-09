//
//  HomeCollectionViewCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
   
    func setupLayout() {
        storeImageView.layer.masksToBounds = false
        storeImageView.layer.borderWidth = 0
        storeImageView.layer.borderColor = UIColor.white.cgColor
        storeImageView.layer.cornerRadius = 12

        storeImageView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        storeImageView.layer.shadowRadius = 4
        storeImageView.layer.shadowOffset = CGSize(width: 4, height: 3.5)
        storeImageView.layer.shadowOpacity = 0.7
    }
    
    func setData(storeData: HomePostRes) {
        storeImageView.kf.setImage(with: URL(string: storeData.postImgUrl))
        storeNameLabel.text = storeData.storeTitle
    }
}
