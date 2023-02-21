//
//  PopularSearchCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit

class PopularSearchCell: UICollectionViewCell {

    @IBOutlet weak var popularLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib() 
        
        setupLayout()
    }
    
    func setupLayout() {
        self.layer.cornerRadius = 13.0
    }
 
    func setBackgroundColor(color: CGColor) {
        self.layer.backgroundColor = color
    }

}
