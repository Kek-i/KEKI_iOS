//
//  SearchDetailCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit

class HeartDetailCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
     
    override func awakeFromNib() {
        super.awakeFromNib()
         
        setupLayout()
    }

    func setupLayout() {
        productImageView.layer.cornerRadius = 10
    }
}

