//
//  BuyerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

class BuyerProfileSetViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    var navigationBackItemTitle: String? = nil
    
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
    
    @IBAction func didTapvVlidateNicknameButton(_ sender: UIButton) {
        // TODO: 입력된 닉네임의 중복확인 처리 후,isValidNicknameLabel 값 설정
    }
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setup() {
        // TODO: 소셜로그인을 통해 받아온 유저의 이메일을 label값으로 보이기
    }
    
    private func setupNavigationBarLayout() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(confirmProfileSetting))
    }
    
    private func setupLayout() {
        nickNameTextField.borderStyle = .none
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
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let home = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        navigationController?.pushViewController(home, animated: true)
    }
}

// MARK: - Extensions
