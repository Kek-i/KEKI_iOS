//
//  DayTableViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/02.
//

import UIKit

class DayTableViewController: UIViewController {

    @IBOutlet weak var dayTableView: UITableView!
    
    let cellSpacingHeight: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func setup() {
        dayTableView.delegate = self
        dayTableView.dataSource = self
    }
    

}


extension DayTableViewController: UITableViewDelegate, UITableViewDataSource {
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
