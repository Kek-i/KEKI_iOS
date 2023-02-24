//
//  HashTagCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/03.
//

import UIKit

class HashTagCell: UICollectionViewCell {
    
    @IBOutlet weak var hashTagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    func setupLayout() {
        self.layer.cornerRadius = 13
        self.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowRadius = 6
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
    }
    
    func setHashTagLabel(hashTag: String) {
        hashTagLabel.text = hashTag
    }
}
