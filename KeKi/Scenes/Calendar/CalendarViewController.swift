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
    var calendarList: Array<CalendarList> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = UserDefaults.standard.object(forKey: "userInfo") {
            setup()
            setupLayout()
            setupDisplay()
            setupNavigationBar()
            fetchCalendarList()
        }
        else { showAlert() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        fetchCalendarList()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "회원가입 후 사용 가능한 서비스입니다", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "홈으로 이동", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: false)
            let main = DefaultTabBarController()
            main.modalPresentationStyle = .fullScreen
            main.modalTransitionStyle = .crossDissolve
            self?.present(main, animated: true)
        }
        let join = UIAlertAction(title: "가입하기", style: .default) { [weak self] _ in
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            guard let signupViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            signupViewController.modalPresentationStyle = .fullScreen
            self?.present(signupViewController, animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(join)
        present(alert, animated: true)
    }
    
    func setup() {
        dayTableView.delegate = self
        dayTableView.dataSource = self
    }
    
    func setupLayout() {
        addDayButton.layer.cornerRadius = addDayButton.frame.width / 2
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupDisplay() {
        if calendarList.count == 0 {
            cherryImageView.isHidden = true
            dayTableView.isHidden = true
            
            noDayCherryImageView.isHidden = false
            noDayLabel.isHidden = false
        } else {
            noDayCherryImageView.isHidden = true
            noDayLabel.isHidden = true
            
            cherryImageView.isHidden = false
            dayTableView.isHidden = false
        }
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
        return calendarList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        
        let calendar = calendarList[indexPath.section]
        
        cell.setupText(title: calendar.title, date: calendar.date, dDay: calendar.calDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dayDetailVC = UIStoryboard(name: "DayDetail", bundle: nil).instantiateViewController(withIdentifier: "DayDetailViewController") as? DayDetailViewController else {return}
        
        let calendar = calendarList[indexPath.section]
        dayDetailVC.calendarIdx = calendar.calendarIdx

        self.navigationController?.pushViewController(dayDetailVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: nil) { (action, view,  completion) in
            let removeCalendar = self.calendarList.remove(at: indexPath.section)
            self.deleteCalendar(calendarIdx: removeCalendar.calendarIdx)
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.deleteSections(indexSet, with: .automatic)
            completion(true)
        }
        
        action.backgroundColor = UIColor(red: 253.0 / 255.0, green: 238.0 / 255.0, blue: 198.0 / 255.0, alpha: 1)
        action.image = UIImage(named: "calendarDelete")


        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = false
        
        return configuration
     }
    
    
}

// 서버 통신 api
extension CalendarViewController {
    func fetchCalendarList() {
        APIManeger.shared.testGetData(urlEndpointString: "/calendars", dataType: CalendarListResponse.self, parameter: nil, completionHandler: { [weak self] response in
            self?.calendarList = response.result
            self?.dayTableView.reloadData()
            self?.setupDisplay()
        })
        
    }
    func deleteCalendar(calendarIdx: Int) {
        APIManeger.shared.testDeleteData(urlEndpointString: "/calendars/\(calendarIdx)") { [weak self] response in
            if response.isSuccess == true {
            self?.fetchCalendarList()
            }
        }
    }
}
