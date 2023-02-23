//
//  imageCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/23.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    func setupLayout() {
        productImage.backgroundColor = .white
        productImage.layer.cornerRadius = 13
        productImage.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
        productImage.layer.shadowOffset = CGSize(width: 3, height: 3)
        productImage.layer.shadowRadius = 6
        productImage.layer.shadowOpacity = 1.0
    }
}
