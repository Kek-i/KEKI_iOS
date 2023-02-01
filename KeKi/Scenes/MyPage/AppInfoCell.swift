//
//  AppInfoCell.swift
//  
//
//  Created by 김초원 on 2023/02/01.
//

import UIKit

class AppInfoCell: UITableViewCell {

    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var viewmoreImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

}
