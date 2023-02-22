//
//  LoginViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKUser

enum Role: String {
    case notUser = "비회원"
    case buyer = "구매자"
    case seller = "판매자"
}

private let SOCIAL_LOGIN_URL_ENDPOINT_STR = "/users/login"

class LoginViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupButtonLayouts()
        
        setupAuthorityGuidanceViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapGoogleLoginButton(_ sender: UIButton) {
        // TODO: 구글 로그인 기능 추가
        print("didTapGoogleLoginButton")
        
        // 유저 정보 설정창으로 전환 처리 (임시 구현, 이후 삭제 예정)
        guard let selectUserCategoryViewController = storyboard?.instantiateViewController(withIdentifier: "SelectUserCategoryViewController") as? SelectUserCategoryViewController else { return }
        navigationController?.pushViewController(selectUserCategoryViewController, animated: true)
    }
    
    @IBAction func didTapKakaoLoginButton(_ sender: UIButton) {
        // TODO: 카카오 로그인 기능 추가
        print("didTapKakaoLoginButton")
        kakaoSocialLogin()
    }
    
    @IBAction func didTapNaverLoginButton(_ sender: UIButton) {
        // TODO: 네이버 로그인 기능 추가
        print("didTapNaverLoginButton")
    }
    
    @IBAction func didTapAppleLoginButton(_ sender: UIButton) {
        // TODO: 애플 로그인 기능 추가
        print("didTapNaverLoginButton")
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupButtonLayouts() {
        [
            googleLoginButton,
            appleLoginButton
        ].forEach {
            $0?.layer.borderColor = UIColor.lightGray.cgColor
            $0?.layer.borderWidth = 0.3
        }
        
        [
            googleLoginButton,
            kakaoLoginButton,
            naverLoginButton,
            appleLoginButton
        ].forEach { $0?.layer.cornerRadius = 25 }

        googleLoginButton.configuration?.imagePadding = 53
        kakaoLoginButton.configuration?.imagePadding = 53
        naverLoginButton.configuration?.imagePadding = 34
        appleLoginButton.configuration?.imagePadding = 48
    }
    
    private func setupAuthorityGuidanceViewController() {
        let storyboard = UIStoryboard.init(name: "AuthorityGuidance", bundle: nil)
        guard let authorityGuidanceViewController = storyboard.instantiateViewController(withIdentifier: "AuthorityGuidanceViewController") as? AuthorityGuidanceViewController else { return }
        authorityGuidanceViewController.modalPresentationStyle = .fullScreen
        present(authorityGuidanceViewController, animated: true)
        
    }
}

// MARK: - Extensions
extension LoginViewController {
    private func kakaoSocialLogin() {
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            // 카톡 설치
            UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
                if let error = error { print(error) }
                else {
                    print("loginWithKakaoTalk() success.")
                    self?.getKakaoUserInfo(oauthToken: oauthToken)
                }
            }
        } else {
            // 카톡 미설치
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                if let error = error { print(error) }
                else {
                    print("loginWithKakaoAccount() success.")
                    self?.getKakaoUserInfo(oauthToken: oauthToken)
                }
            }
        }
    }
}

extension LoginViewController {
    private func getKakaoUserInfo(oauthToken: OAuthToken?) {
        UserApi.shared.me { [self] user, error in
            if let error = error {
                print(error)
            } else {
                
                guard let email = user?.kakaoAccount?.email else{
                    print("email is nil")
                    return
                }
                requestSocialLogin(email: email, provider: "카카오")
            }
        }
    }
    
    private func requestSocialLogin(email: String, provider: String) {
        let param = SocialLoginRequest(email: email, provider: provider)
        APIManeger.shared.postSignup(urlEndpointString: SOCIAL_LOGIN_URL_ENDPOINT_STR,
                                   dataType: SocialLoginRequest.self,
                                   parameter: param,
                                   completionHandler: { [weak self] result in

            print("result :: \(result)")
            // 발급받은 토큰 저장
            let accessToken = result.result.accessToken
            let refreshToken = result.result.refreshToken
            
            UserDefaults.standard.set(email, forKey: "socialEmail")
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
            UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
            
            let role = result.result.role
            switch role {
            case Role.notUser.rawValue:
                self?.signup()
                
            case Role.buyer.rawValue, Role.seller.rawValue:
                APIManeger.shared.setUserInfo(userInfo: result.result)
                self?.showMain()
                
            default:
                print("알 수 없는 유저")
            }
        })
    }

    private func signup() {
        guard let selectUserCategoryViewController = storyboard?.instantiateViewController(withIdentifier: "SelectUserCategoryViewController") as? SelectUserCategoryViewController else { return }
        navigationController?.pushViewController(selectUserCategoryViewController, animated: true)
    }
    
    private func showMain() {
        let main = DefaultTabBarController()
        main.modalPresentationStyle = .fullScreen
        main.modalTransitionStyle = .crossDissolve
        self.present(main, animated: true)
    }
}

