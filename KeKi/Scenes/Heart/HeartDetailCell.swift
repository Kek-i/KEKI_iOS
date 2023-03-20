//
//  SearchDetailCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit
import Kingfisher

class HeartDetailCell: UICollectionViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    private var heartFeed: HeartFeed?
    
    private var first = true
     
    override func awakeFromNib() {
        super.awakeFromNib()
         
        setupLayout()
    }
    
    func setup() {
        if heartFeed != nil {
            productTitleLabel.text = heartFeed?.dessertName
            productPriceLabel.text = heartFeed?.dessertPrice.description
            
            productImageView.kf.setImage(with: URL(string: heartFeed!.postImgUrl))
        }
    }

    func setupLayout() {
        productImageView.layer.cornerRadius = 10
    }
    
    func setHeartFeed(heartFeed: HeartFeed) {
        self.heartFeed = heartFeed
    }
    
    func setFirst(first: Bool) {
        self.first = first
    }
    
    func isFirst() -> Bool {
        return self.first
    }
    
    func getPostIdx() -> Int {
        return self.heartFeed!.postIdx
    }
}

