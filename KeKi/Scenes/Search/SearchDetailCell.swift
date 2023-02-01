//
//  SearchDetailCell.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class SearchDetailCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIInit()
    }

    func UIInit() {
        productImageView.layer.cornerRadius = 10
    }
}
