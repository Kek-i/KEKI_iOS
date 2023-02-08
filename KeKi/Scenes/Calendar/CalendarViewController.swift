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
    
    
    @IBOutlet weak var cherryImageView: UIImageView!
    @IBOutlet weak var dayTableView: UITableView!
    
    
    @IBOutlet weak var noDayCherryImageView: UIImageView!
    @IBOutlet weak var noDayLabel: UILabel!
    
    
    // 서버 연결 후 삭제 - 임시 데이터
    var dDayList: Array<String> = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setup() {
        dayTableView.delegate = self
        dayTableView.dataSource = self
        
        //임시로 만들어 개수로 기념일 있을 시와 없을 시 구분 -> 데이터 연결 시 삭제
        if dDayList.count == 3 {
            cherryImageView.isHidden = true
            dayTableView.isHidden = true
            
            noDayCherryImageView.isHidden = false
            noDayLabel.isHidden = false
        } else if dDayList.count == 4 {
            noDayCherryImageView.isHidden = true
            noDayLabel.isHidden = true
            
            cherryImageView.isHidden = false
            dayTableView.isHidden = false
        }
    }
    
    func setupLayout() {
        addDayButton.layer.cornerRadius = addDayButton.frame.width / 2
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func addDay(_ sender: Any) {
        guard let dayAddVC = UIStoryboard(name: "DayAddViewController", bundle: nil).instantiateViewController(withIdentifier: "DayAddViewController") as? DayAddViewController else {return}
                
        self.navigationController?.pushViewController(dayAddVC, animated: true)
                
    }
}


extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dayDetailVC = UIStoryboard(name: "DayDetail", bundle: nil).instantiateViewController(withIdentifier: "DayDetailViewController") as? DayDetailViewController else {return}
                
        // 네비게이션 사용 시 Fix
        self.navigationController?.pushViewController(dayDetailVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view,  completion) in
                tableView.deleteRows(at: [indexPath], with: .automatic)
             completion(true)
        }
        
        action.backgroundColor = UIColor(red: 253.0 / 255.0, green: 238.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
        action.title = "삭제"


        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
     }
    
    
}
