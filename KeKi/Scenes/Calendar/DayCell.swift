//
//  TableViewCell.swift
//  KeKi
//
//  Created by 유상 on 2023/02/02.
//

import UIKit

class DayCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
    }
    
    func setup(title: String, date: String, dDay: String){
        titleLabel.text = title
        dateLabel.text = date
        dDayLabel.text = dDay
    }
    
    func setupLayout() {
        contentView.layer.cornerRadius = 10
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
}
