//
//  StoreImageCell.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import UIKit

class StoreImageCell: UICollectionViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }

    func setupLayout() {
        storeImageView.layer.cornerRadius = 10
    }
    
}
