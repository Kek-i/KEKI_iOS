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
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapGoogleLoginButton(_ sender: UIButton) {
        // TODO: 구글 로그인 기능 추가
        print("didTapGoogleLoginButton")
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
        kakaoLoginButton.configuration?.imagePadding = 51
        naverLoginButton.configuration?.imagePadding = 45
        appleLoginButton.configuration?.imagePadding = 45 
    }
}

// MARK: - Extensions
