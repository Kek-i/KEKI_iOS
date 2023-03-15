//
//  LoginViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

import Alamofire

import KakaoSDKAuth
import KakaoSDKUser
import NaverThirdPartyLogin
import AuthenticationServices

enum Role: String {
    case notUser = "비회원"
    case buyer = "구매자"
    case seller = "판매자"
}

private let SOCIAL_LOGIN_URL_ENDPOINT_STR = "/users/login"

@available(iOS 13.0, *)
class LoginViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var naverLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: ASAuthorizationAppleIDButton!
    
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupButtonLayouts()
        setupAuthorityGuidanceViewController()
        
        // apple login button setup
        appleLoginButton.addTarget(self, action: #selector(didTapAppleLoginButton(_:)), for: .touchUpInside)
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
        naverSocialLogin()
    }
    
    @IBAction func didTapAppleLoginButton(_ sender: UIButton) {
        // TODO: 애플 로그인 기능 추가
        print("didTapAppleLoginButton")
        appleSocialLogin()
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
//        appleLoginButton.configuration?.imagePadding = 48
    }
    
    private func setupAuthorityGuidanceViewController() {
        let storyboard = UIStoryboard.init(name: "AuthorityGuidance", bundle: nil)
        guard let authorityGuidanceViewController = storyboard.instantiateViewController(withIdentifier: "AuthorityGuidanceViewController") as? AuthorityGuidanceViewController else { return }
        authorityGuidanceViewController.modalPresentationStyle = .fullScreen
        present(authorityGuidanceViewController, animated: true)
        
    }
    
    // MARK: @objc methods
    @objc func didTapAppleLoginButton() {
        let authorizationProvider = ASAuthorizationAppleIDProvider()
        let request = authorizationProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

// MARK: - NAVER Social Login Delegate
extension LoginViewController : NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() { getNaverUserInfo() }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() { getNaverUserInfo() }
    
    func oauth20ConnectionDidFinishDeleteToken() { getNaverUserInfo() }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Naver Login ERROR :: \(error.localizedDescription)")
    }
}

// MARK: - APPLE Social Login Delegate
extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        print("Apple ID Credential Authorization User ID : \(appleIDCredential.user)")
        print("Apple ID Credential Authorization User Email : \(appleIDCredential.email)")
        
        if let email = UserDefaults.standard.value(forKey: "appleEmail") {
            requestSocialLogin(email: email as! String, provider: "애플")
            
        } else if let email = appleIDCredential.email {
            UserDefaults.standard.set(email, forKey: "appleEmail")
            requestSocialLogin(email: email, provider: "애플")
        }

    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple ID Credential failed with error : \(error.localizedDescription)")
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
} 


// MARK: - Social Login GetUserInfo Methods
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
    
    private func naverSocialLogin() {
        print("naverSocialLogin called")
        naverLoginInstance?.delegate = self
        naverLoginInstance?.requestThirdPartyLogin()
    }
    
    private func appleSocialLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
    
    private func getNaverUserInfo() {
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
                guard let result = response.value as? [String: Any] else { return }
//                guard let object = result["response"] as? [String: Any] else { return }
//                guard let name = object["name"] as? String else { return }
//                guard let email = object["email"] as? String else { return }
//                guard let id = object["id"] as? String else {return}
                
                print(result)
              }
    }
    
    private func requestSocialLogin(email: String, provider: String) {
        let param = SocialLoginRequest(email: email, provider: provider)
        APIManeger.shared.postSignup(urlEndpointString: SOCIAL_LOGIN_URL_ENDPOINT_STR,
                                   dataType: SocialLoginRequest.self,
                                   parameter: param,
                                   completionHandler: { [weak self] result in

            
            if let result = result.result {
                // 발급받은 토큰 저장
//                let accessToken = result.accessToken
//                let refreshToken = result.refreshToken
//
                UserDefaults.standard.set(email, forKey: "socialEmail")
//                UserDefaults.standard.set(accessToken, forKey: "accessToken")
//                UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
                
                let role = result.role
                switch role {
                case Role.notUser.rawValue:
                    APIManeger.shared.setUserInfo(userInfo: result)
                    let userInfo = result
                    let encoded = try? PropertyListEncoder().encode(userInfo)
                    UserDefaults.standard.set(encoded, forKey: "userInfo")
                    self?.signup()
                    
                case Role.buyer.rawValue, Role.seller.rawValue:
                    APIManeger.shared.setUserInfo(userInfo: result)
                    
                    let encoder = JSONEncoder()
                    if let encoded = try? encoder.encode(result) {
                        UserDefaults.standard.setValue(encoded, forKey: "userInfo")
                    }
                    self?.showMain()
                    
                default:
                    print("알 수 없는 유저")
                }
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

