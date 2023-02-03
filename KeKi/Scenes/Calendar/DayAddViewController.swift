//
//  DayAddViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/03.
//

import UIKit

class DayAddViewController: UIViewController {
    
    @IBOutlet weak var dayTypeLabel: UILabel!
    
    @IBOutlet weak var dayTypeSelectButton: UIButton!
    @IBOutlet weak var dDayButton: UIButton!
    @IBOutlet weak var dayNumButton: UIButton!
    @IBOutlet weak var dayRepeatButton: UIButton!
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var dateSelectButton: UIButton!
    @IBOutlet weak var dateSelectPicker: UIDatePicker!
    
    @IBOutlet weak var selectButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var datePickerViewHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func selectDayType(_ sender: Any) {
        selectButtonViewHeight.priority = UILayoutPriority(100)
    }
    
    
    @IBAction func selectDate(_ sender: Any) {
        datePickerViewHeight.priority = UILayoutPriority(240)
    }
    

}
