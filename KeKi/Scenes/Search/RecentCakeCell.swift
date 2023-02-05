//
//  RecentCakeCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit

class RecentCakeCell: UICollectionViewCell {

    @IBOutlet weak var recentCakeImageView: UIImageView!{
        didSet{
            recentCakeImageView.layer.cornerRadius = 10
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
         
        self.layer.shadowColor = CGColor(red: 167.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 0.25)
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowOpacity = 5.0
    }

}
