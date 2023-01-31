//
//  HomeCollectionViewCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var storeNameLabel: UILabel!
    
    func setupLayout() {
        storeImageView.layer.cornerRadius = 28
        
        storeImageView.layer.masksToBounds = false
        storeImageView.layer.borderWidth = 0
        storeImageView.layer.borderColor = UIColor.white.cgColor
        storeImageView.layer.cornerRadius = 12

        storeImageView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        storeImageView.layer.shadowRadius = 4
        storeImageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        storeImageView.layer.shadowOpacity = 1.0
    }
    
}
