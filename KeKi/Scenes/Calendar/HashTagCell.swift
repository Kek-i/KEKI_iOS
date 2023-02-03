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
    }
    
    func sethasTagLabel(hashTag: String) {
        hashTagLabel.text = hashTag
    }
}
