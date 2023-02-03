//
//  CalendarViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/02.
//

import UIKit



class CalendarViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addDayButton: UIButton!
    
    
    // 서버 연결 후 삭제 - 임시 데이터
    var dDayList: Array<String> = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    func setup() {
        //임시로 만들어 개수로 기념일 있을 시와 없을 시 구분 -> 데이터 연결 시 삭제
        if dDayList.count == 3 {
            let dayNothingVC = UIStoryboard(name: "DayNothingViewController", bundle: nil).instantiateViewController(withIdentifier: "DayNothingViewController")
            
            containerView.addSubview(dayNothingVC.view)
            dayNothingVC.didMove(toParent: self)
            self.addChild(dayNothingVC)
        } else if dDayList.count == 4 {
            guard let dayTableVC = UIStoryboard(name: "DayTableViewController", bundle: nil).instantiateViewController(withIdentifier: "DayTableViewController") as? DayTableViewController else {return}
            
            containerView.addSubview(dayTableVC.view)
            dayTableVC.didMove(toParent: self)
            self.addChild(dayTableVC)
            
        }
    }
    
    func setupLayout() {
        addDayButton.layer.cornerRadius = addDayButton.frame.width / 2
    }
    
    @IBAction func addDay(_ sender: Any) {
        let dayAddVC = DayAddViewController(nibName: "DayAddViewController", bundle: nil)
        
        self.present(dayAddVC, animated: true)
                
    }
}
