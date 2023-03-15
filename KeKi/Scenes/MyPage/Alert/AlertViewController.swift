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

}

// MARK: - Extensions
extension AlertViewController {
    func logout() {
        APIManeger.shared.testPatchData(urlEndpointString: LOGOUT_ENDPOINT_STR,
                                        dataType: GeneralResponseModel.self,
                                        parameter: nil,
                                        completionHandler: { [weak self] response in
            print(response)
            let instance = NaverThirdPartyLoginConnection.getSharedInstance()
            instance?.requestDeleteToken()
            APIManeger.shared.resetHeader()
            
            self?.navigationController?.popToRootViewController(animated: false)
            let main = DefaultTabBarController()
            main.modalPresentationStyle = .fullScreen
            main.modalTransitionStyle = .crossDissolve
            self?.present(main, animated: true)
        })
    }
    
    func signout() {
        // TODO: 회원탈퇴 기능 구현 (탈퇴 후 응답X, 재로그인시 AF 오류 발생함)
    
        APIManeger.shared.testDeleteData(urlEndpointString: SIGNOUT_ENDPOINT_STR,
                                         completionHandler: { [weak self] response in
            APIManeger.shared.resetHeader()
            switch response.isSuccess {
            case true:
                self?.dismiss(animated: true)
            case false:
                self?.dismiss(animated: true)
            default:
                return
            }
        })
    }
}
