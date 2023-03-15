//
//  UnLoginMyPageViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

enum PolicyKind: String {
    case tosPolicy = "https://sites.google.com/view/keki-tos/홈"
    case privatePolicy = "https://sites.google.com/view/keki-privacy-policy/%ED%99%88"
}

class UnLoginMyPageViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var appInfoTitleList: [String] = [
        "회원가입", "공지사항", "약관안내", "개인정보처리방침"
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        
        let title = UILabel()
        title.text = "내 정보"
        title.font = .systemFont(ofSize: 22, weight: .bold)
        title.sizeToFit()

        let leftItem = UIBarButtonItem(customView: title)
        self.navigationItem.leftBarButtonItem = leftItem
        
        let messageBarItem = UIBarButtonItem(image: UIImage(named: "mypageMessage"), style: .plain, target: self, action: #selector(didTapMessageBarItem))
        let notificationBarItem = UIBarButtonItem(image: UIImage(named: "mypageNotification"), style: .plain, target: self, action: #selector(didTapNotificationBarItem))
        navigationItem.rightBarButtonItems = [notificationBarItem, messageBarItem]
    }
    
    private func setupTableView() {
        appInfoTableView.dataSource = self
        appInfoTableView.delegate = self
        
        appInfoTableView.isScrollEnabled = false
        appInfoTableView.layer.masksToBounds = false
        appInfoTableView.layer.borderWidth = 0
        appInfoTableView.layer.borderColor = UIColor.white.cgColor
        appInfoTableView.layer.cornerRadius = 10
        
        appInfoTableView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        appInfoTableView.layer.shadowOpacity = 0.2
        appInfoTableView.layer.shadowRadius = 11
        appInfoTableView.layer.shadowOffset = CGSize(width: 6, height: 6)
    }
    
    private func loadSignup() {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        guard let signupViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        navigationController?.pushViewController(signupViewController, animated: true)
    }
    
    private func loadAnnouncement() {
        let storyboard = UIStoryboard.init(name: "Announcement", bundle: nil)
        guard let announcementViewController = storyboard.instantiateViewController(withIdentifier: "AnnouncementViewController") as? AnnouncementViewController else { return }
        
        let backItem = UIBarButtonItem()
        backItem.title = "내 정보"
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.pushViewController(announcementViewController, animated: true)
    }
    
    private func loadPolicyWebView(pollicyKind: PolicyKind) {
        let storyboard = UIStoryboard.init(name: "PolicyWebView", bundle: nil)
        guard let policyWebViewController = storyboard.instantiateViewController(withIdentifier: "PolicyWebViewController") as? PolicyWebViewController else { return }
        
        switch pollicyKind {
        case .tosPolicy:
            let encodedTosUrlString = PolicyKind.tosPolicy.rawValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            policyWebViewController.setUrlString(urlString: encodedTosUrlString!)
        case .privatePolicy:
            policyWebViewController.setUrlString(urlString: PolicyKind.privatePolicy.rawValue)
        }
        
        navigationController?.pushViewController(policyWebViewController, animated: true)

    }

    // MARK: @objc methods
    @objc private func didTapMessageBarItem() {
        let alert = UIAlertController(title: "안내", message: "채팅 기능은 곧 업데이트될 예정입니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func didTapNotificationBarItem() {
        let alert = UIAlertController(title: "안내", message: "알림 기능은 곧 업데이트될 예정입니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Extensions
extension UnLoginMyPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfoTitleList.count    // default numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = appInfoTitleList[indexPath.row]
        if indexPath.row != 1 { cell.viewmoreImageView.isHidden = true }
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
            loadSignup()
        case 1:
            loadAnnouncement()
        case 2:
            loadPolicyWebView(pollicyKind: .tosPolicy)
            return
        case 3:
            loadPolicyWebView(pollicyKind: .privatePolicy)
        default:
            return
        }
    }
}
