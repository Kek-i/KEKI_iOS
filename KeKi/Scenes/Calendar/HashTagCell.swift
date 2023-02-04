//
//  HashTagCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/03.
//

import UIKit

class HashTagCell: UICollectionViewCell {
    
    @IBOutlet weak var hashTagLabel: UILabel!
    
    var isSelect: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupLayout()
    }
    
    func setupLayout() {
        self.layer.cornerRadius = 13
    }
    
    func setHashTagLabel(hashTag: String) {
        hashTagLabel.text = hashTag
    }
}
