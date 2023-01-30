//
//  SellerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

class SellerProfileSetViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var storeAddressTextField: UITextField!
    @IBOutlet weak var storeIntroTextView: UITextView!
    @IBOutlet weak var orderLinkTextField: UITextField!
    
    // 사업자 정보 관련은 모두 맨 앞에 'b'추가
    @IBOutlet weak var bStoreNameTextField: UITextField!
    @IBOutlet weak var bRepresentativeNameTextField: UITextField!
    
    @IBOutlet weak var bAddressTextView: UITextView!
    @IBOutlet weak var bCompRegistNumTextField: UITextField!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarLayout()
        setupLayout()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapSelectPicButton(_ sender: UIButton) {
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupLayout() {
        [
            storeNameTextField,
            storeAddressTextField,
            orderLinkTextField,
            
            bStoreNameTextField,
            bRepresentativeNameTextField,
            bCompRegistNumTextField
            
        ].forEach {
            $0.borderStyle = .none
            $0.addLeftPadding()
        }
        
        [ storeIntroTextView, bAddressTextView ].forEach {
            $0?.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
        
        
        [
            storeNameTextField,
            storeAddressTextField,
            storeIntroTextView,
            orderLinkTextField,
            
            bStoreNameTextField,
            bRepresentativeNameTextField,
            bAddressTextView,
            bCompRegistNumTextField
            
        ].forEach {
            $0?.layer.masksToBounds = false
            $0?.layer.borderWidth = 0
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 12

            $0?.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
            $0?.layer.shadowRadius = 6
            $0?.layer.shadowOffset = CGSize(width: 3, height: 3)
            $0?.layer.shadowOpacity = 0.2
        }
    }
    
    private func setupNavigationBarLayout() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(confirmProfileSetting))
    }
    
    @objc private func confirmProfileSetting() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let home = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        navigationController?.pushViewController(home, animated: true)
    }
}

// MARK: - Extensions
