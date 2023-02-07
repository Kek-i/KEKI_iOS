//
//  UIDevice+.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/08.
//

import Foundation
import UIKit

extension UIDevice {
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
