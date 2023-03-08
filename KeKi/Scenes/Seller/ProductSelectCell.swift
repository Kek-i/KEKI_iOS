//
//  ProductSelectCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/28.
//

import UIKit

class ProductSelectCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setProductName(productName: String) {
        productNameLabel.text = productName
    }

}
