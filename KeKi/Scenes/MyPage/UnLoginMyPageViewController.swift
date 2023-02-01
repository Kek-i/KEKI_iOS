//
//  UnLoginMyPageViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

class UnLoginMyPageViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var appInfoTitleList: [String] = [
        "공지사항", "약관안내", "개인정보처리방침"
    ]
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var appInfoTableView: UITableView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        
        let title = UILabel()
        title.text = "내 정보"
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.sizeToFit()

        let leftItem = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let messageBarItem = UIBarButtonItem(image: UIImage(named: "mypageMessage"), style: .plain, target: self, action: nil)
        let notificationBarItem = UIBarButtonItem(image: UIImage(named: "mypageNotification"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [notificationBarItem, messageBarItem]
    }
    
    private func setupTableView() {
        appInfoTableView.dataSource = self
        appInfoTableView.delegate = self
        
        appInfoTableView.layer.masksToBounds = false
        appInfoTableView.layer.borderWidth = 0
        appInfoTableView.layer.borderColor = UIColor.white.cgColor
        appInfoTableView.layer.cornerRadius = 10
        
        appInfoTableView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        appInfoTableView.layer.shadowOpacity = 0.3
        appInfoTableView.layer.shadowRadius = 10
        appInfoTableView.layer.shadowOffset = CGSize(width: 6, height: 6)
    }
}

// MARK: - Extensions
extension UnLoginMyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3    // default numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfoCell", for: indexPath) as? AppInfoCell else { return UITableViewCell() }
        cell.noticeLabel.text = appInfoTitleList[indexPath.row]
        if indexPath.row != 0 { cell.viewmoreImageView.isHidden = true }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60   // default height
    }
    
}

extension UnLoginMyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch indexPath.row {
        case 0:
            // TODO: 공지 목록 화면으로 이동
            print("TODO: 공지 목록 화면으로 이동")
        case 1:
            // TODO: 약관 안내
            print("TODO: 약관 안내")
        case 2:
            // TODO: 개인정보처리방침으로 이동
            print("TODO: 개인정보처리방침으로 이동")
        default:
            print("None")
        }
    }
}
