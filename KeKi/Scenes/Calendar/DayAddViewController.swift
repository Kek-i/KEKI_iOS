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
    
    var isSelectViewOpen = false
    var isDatePickerViewOpen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func selectDayType(_ sender: Any) {
        if isSelectViewOpen == false {
            selectButtonViewHeight.priority = UILayoutPriority(100)
        }else {
            selectButtonViewHeight.priority = UILayoutPriority(1000)
        }
        
        
        isSelectViewOpen.toggle()
    }
    
    
    @IBAction func selectDate(_ sender: Any) {
        if isDatePickerViewOpen == false {
            datePickerViewHeight.priority = UILayoutPriority(240)
        }else {
            datePickerViewHeight.priority = UILayoutPriority(1000)
        }
        
        isDatePickerViewOpen.toggle()
    }
    

}
