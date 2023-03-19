//
//  AlertViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/01.
//

import UIKit
import NaverThirdPartyLogin

private let LOGOUT_ENDPOINT_STR = "/users/logout"
private let SIGNOUT_ENDPOINT_STR = "/users/signout"

enum Todo {
    case logout
    case signout
}

class AlertViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var todo: Todo?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapCancelButton(_ sender: UIButton) { dismiss(animated: true) }
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        // TODO: 로그아웃/탈퇴 기능 구현
        switch todo {
            case .logout: logout()
            case .signout: signout()
            default: return
        }
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    func config(todo: Todo) { self.todo = todo }

    private func setupLayout() {
        
        containerView.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 12
        confirmButton.layer.cornerRadius = 12
        
        switch todo {
        case .logout:
            titleLabel.text = "로그아웃"
            contentLabel.text = "로그아웃 하시겠습니까?"
            confirmButton.setTitle("로그아웃", for: .normal)
        case .signout:
            titleLabel.text = "회원탈퇴"
            contentLabel.text = "정말 케키와 헤어지실건가요? \n정말요?  진짜요?\n(해당 이메일로 재가입은 불가능합니다)"
            confirmButton.setTitle("탈퇴하기", for: .normal)
        default:
            return
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
    }
    
    private func logout() { requestAuth(urlString: LOGOUT_ENDPOINT_STR) }
    private func signout() { requestAuth(urlString: SIGNOUT_ENDPOINT_STR) }
    
    private func requestAuth(urlString: String) {
        // 로그아웃 or 회원탈퇴 처리 메소드
        switch todo {
        case .logout: logoutRequest(urlString: urlString)
        case .signout: signoutRequest(urlString: urlString)
        default: return 
        }
    }
    
    private func logoutRequest(urlString: String) {
        APIManeger.shared.testPatchData(urlEndpointString: urlString,
                                        dataType: GeneralResponseModel.self,
                                        parameter: nil,
                                        completionHandler: { [weak self] response in
            let instance = NaverThirdPartyLoginConnection.getSharedInstance()
            instance?.requestDeleteToken()
            APIManeger.shared.resetHeader()
            self?.showMain()
        })
    }
    
    private func signoutRequest(urlString: String) {
        APIManeger.shared.testDeleteData(urlEndpointString: urlString,
                                         completionHandler: { [weak self] response in
            let instance = NaverThirdPartyLoginConnection.getSharedInstance()
            instance?.requestDeleteToken()
            APIManeger.shared.resetHeader()
            self?.showMain()
        })
    }
    
    private func showMain() {
        self.navigationController?.popToRootViewController(animated: false)
        let main = DefaultTabBarController()
        main.modalPresentationStyle = .fullScreen
        main.modalTransitionStyle = .crossDissolve
        self.present(main, animated: true)
    }

}
