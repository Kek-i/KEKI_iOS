//
//  RecentSearchCell.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class RecentSearchCell: UICollectionViewCell {
 
    @IBOutlet weak var recentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 13.0
        self.layer.borderWidth = 1.5
        self.layer.borderColor = CGColor(red: 227.0 / 255.0, green: 227.0 / 255.0, blue: 227.0 / 255.0, alpha: 1)
        
        self.layer.backgroundColor = CGColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
    }

}
