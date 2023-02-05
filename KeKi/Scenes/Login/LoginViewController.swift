//
//  LoginViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

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
