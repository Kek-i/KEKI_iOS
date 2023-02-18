//
//  BuyerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

private let NICKNAME_VALIDATION_ENDPOINT = "/users/nickname"
private let SIGNUP_ENDPOINT = "/users/signup"

class BuyerProfileSetViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    var navigationBackItemTitle: String? = nil
    private var isValidNickname: Bool = false
    private var validNickname: String? = nil
    
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var validateNicknameButton: UIButton!
    @IBOutlet weak var isValidNicknameLabel: UILabel!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarLayout()
        setupLayout()
        setup()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapSelectPictureButton(_ sender: UIButton) {
        // TODO: 사진 저장공간으로 접근 처리 (임시 구현)
    }
    
    @IBAction func didTapvVlidateNicknameButton(_ sender: UIButton) { checkNicknameValidation() }
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setup() {
        // TODO: 소셜로그인을 통해 받아온 유저의 이메일을 label값으로 보이기
        let email = UserDefaults.standard.value(forKey: "socialEmail") as! String
        userEmailLabel.text = email

    }
    
    private func setupNavigationBarLayout() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(confirmProfileSetting))
    }
    
    private func setupLayout() {
        nickNameTextField.borderStyle = .none
        nickNameTextField.addLeftPadding()
        [nickNameTextField, validateNicknameButton].forEach {
            $0?.layer.masksToBounds = false
            $0?.layer.borderWidth = 0
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 12
            
            $0?.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
            $0?.layer.shadowRadius = 8
            $0?.layer.shadowOffset = CGSize(width: 3, height: 3)
            $0?.layer.shadowOpacity = 0.2
        }
    }
    
    @objc private func confirmProfileSetting() {
        print("완료 버튼 탭함")
        signup()
        
    }
}

// MARK: - Extensions
extension BuyerProfileSetViewController {
    private func checkNicknameValidation() {
        let inputNickname = NicknameValid(nickname: nickNameTextField.text ?? "")
        
        APIManeger.shared.postData(urlEndpointString: NICKNAME_VALIDATION_ENDPOINT,
                                   dataType: NicknameValid.self,
                                   header: nil,
                                   parameter: inputNickname,
                                   completionHandler: { [weak self] result in
            switch result.code {
            case 1000:
                self?.isValidNicknameLabel.text = "사용 가능한 닉네임입니다."
                self?.isValidNicknameLabel.textColor = .gray
                self?.isValidNickname = true
                self?.validNickname = inputNickname.nickname
            case 3001:
                self?.isValidNicknameLabel.text = "이미 사용중인 닉네임입니다."
                self?.isValidNicknameLabel.textColor = .red
                self?.isValidNickname = false
            default:
                return
            }
            self?.isValidNicknameLabel.isHidden = false

        })
    }
    
    private func signup() {
        if let nickname = nickNameTextField.text {
            let imgUrl = "" // 임시
            let signupInfo = Signup(nickname: nickname, profileImg: imgUrl)
            signupRequest(param: signupInfo)
            
        } else { showAlert(message: "닉네임을 입력해주세요") }
    }
    
    private func signupRequest(param: Signup) {
        let accessToken = UserDefaults.standard.value(forKey: "accessToken") as! String
        let headers = APIManeger.shared.getHeaderByToken(accessToken: accessToken)
        
        APIManeger.shared.postSignup(urlEndpointString: SIGNUP_ENDPOINT,
                                   dataType: Signup.self,
                                   header: headers,
                                   parameter: param,
                                   completionHandler: { [weak self] response in
            switch response.code {
            case 1000:
                print("회원가입 성공")
                let userInfo = response.result
                
                let encoder = JSONEncoder()
                let encoded = try? PropertyListEncoder().encode(userInfo)
                UserDefaults.standard.set(encoded, forKey: "userInfo")
                
                let main = DefaultTabBarController()
                main.modalPresentationStyle = .fullScreen
                main.modalTransitionStyle = .crossDissolve
                self?.present(main, animated: true)
                
            default:
                print("회원가입 실패 :: \(response.message)")
                self?.showAlert(message: "네트워크 오류로 인해 회원가입에 실패하였습니다.")
            }
            
        })
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
    }

}

