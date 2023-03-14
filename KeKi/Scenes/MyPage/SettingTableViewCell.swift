//
//  settingTableViewCell.swift
//  
//
//  Created by 김초원 on 2023/02/01.
//

import UIKit
import UserNotifications

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewmoreImageView: UIImageView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setNotificationSetSwitch()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }

    private func setNotificationSetSwitch() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound]) { [weak self] (didAllow, error) in
            guard let err = error else {
                print(didAllow)
                DispatchQueue.main.async {
                    if didAllow { self?.notificationSwitch?.isOn = true }
                    else { self?.notificationSwitch?.isOn = false }
                }
                return
            }

            print(err.localizedDescription)
        }
    }
}
