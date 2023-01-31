//
//  AnnouncementCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class AnnouncementCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        let cellInset = 15.0
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: cellInset, left: cellInset, bottom: 0, right: cellInset))
    }
    
    func setupLayout() {
        contentView.layer.masksToBounds = false
        contentView.backgroundColor = .white
        contentView.layer.borderWidth = 0
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.cornerRadius = 15
        
        contentView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        contentView.layer.shadowRadius = 6
        contentView.layer.shadowOffset = CGSize(width: 3, height: 3)
        contentView.layer.shadowOpacity = 0.2
    }
    
}
