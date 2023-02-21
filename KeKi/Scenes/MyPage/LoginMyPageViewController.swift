//
//  LoginMyPageViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/01.
//

import UIKit

enum UserKind {
    case buyer
    case seller
}

enum SectionModel {
    case accountSetting(titleList: [String])
    case nofiticationSetting(titleList: [String])
    case appInfo(titleList: [String])
}

class LoginMyPageViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    var userKind: UserKind? = .buyer
    
    private var sections = [ "계정 설정", "알림 설정", "앱 정보" ]
    
    private var accountSettingTitles = [ "프로필 편집", "로그아웃", "회원탈퇴" ]
    private var nofiticationSettingTitles = [ "푸시 알림" ]
    private var appInfoTitles = [ "공지사항", "약관안내", "개인정보처리방침" ]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
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
    @IBAction func changedNotificationSwitchValue(_ sender: UISwitch) {
        // TODO: switch 값에 따라 푸시 알림 설정 값 변경하기
    }
    
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
        
        let messageBarItem = UIBarButtonItem(image: UIImage(named: "mypageMessage"), style: .plain, target: self, action: nil)
        let notificationBarItem = UIBarButtonItem(image: UIImage(named: "mypageNotification"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [notificationBarItem, messageBarItem]
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        setShadow(tableView)
    }
    
    private func setShadow(_ tableView: UITableView) {
        tableView.layer.masksToBounds = false
        tableView.layer.borderWidth = 0
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.cornerRadius = 10
        
        tableView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        tableView.layer.shadowOpacity = 0.2
        tableView.layer.shadowRadius = 11
        tableView.layer.shadowOffset = CGSize(width: 6, height: 6)
    }
    
    
    ///
    ///
    /// cell did tap action methods
    ///
    ///
    private func editProfile() {
        let storyboard = UIStoryboard.init(name: "UserProfileSetting", bundle: nil)
        let next: UIViewController?
        switch userKind {
        case .buyer:
            next = storyboard.instantiateViewController(withIdentifier: "BuyerProfileSetViewController") as? BuyerProfileSetViewController

        case .seller:
            next = storyboard.instantiateViewController(withIdentifier: "SellerProfileSetViewController") as? SellerProfileSetViewController
        default:
            next = UIViewController()
        }
        if let next = next {
            let backItem = UIBarButtonItem()
            backItem.title = "마이페이지"
            navigationItem.backBarButtonItem = backItem
            navigationController?.pushViewController(next, animated: true)

        }
    }
    
    private func logout() {
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.config(todo: .logout)
        alertViewController.modalPresentationStyle = .fullScreen
        present(alertViewController, animated: true)
    }
    
    private func secession() {
        let storyboard = UIStoryboard.init(name: "Alert", bundle: nil)
        guard let alertViewController = storyboard.instantiateViewController(withIdentifier: "AlertViewController") as? AlertViewController else { return }
        alertViewController.config(todo: .secession)
        alertViewController.modalPresentationStyle = .fullScreen
        present(alertViewController, animated: true)
    }
    
    private func showAnnouncement() {
        let storyboard = UIStoryboard.init(name: "Announcement", bundle: nil)
        guard let announcementViewController = storyboard.instantiateViewController(withIdentifier: "AnnouncementViewController") as? AnnouncementViewController else { return }
        
        let backItem = UIBarButtonItem()
        backItem.title = "마이페이지"
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
    
}

// MARK: - Extensions
extension LoginMyPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }

        switch indexPath.section {
        case 0:
            cell.titleLabel.text = accountSettingTitles[indexPath.row]
            if indexPath.row == 0 { cell.viewmoreImageView.isHidden = false }
        case 1:
            print(indexPath.row)
            cell.titleLabel.text = nofiticationSettingTitles[indexPath.row]
            cell.notificationSwitch.isHidden = false
        case 2:
            cell.titleLabel.text = appInfoTitles[indexPath.row]
            if indexPath.row == 0 { cell.viewmoreImageView.isHidden = false }
        default:
            cell.titleLabel.text = "Not Found"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60   // default height
    }
}

extension LoginMyPageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        header.textLabel?.frame = header.bounds
        header.textLabel?.textAlignment = .left
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                editProfile()
            case 1:
                logout()
                return
            case 2:
                secession()
                return
            default:
                return
            }
        case 2:
            switch indexPath.row {
            case 0:
                showAnnouncement()
            case 1:
                loadPolicyWebView(pollicyKind: .tosPolicy)
                return
            case 2:
                loadPolicyWebView(pollicyKind: .privatePolicy)
            default:
                return
            }
        default:
            return
        }
    }
}
