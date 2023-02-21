//
//  SellerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

class SellerProfileSetViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private let imagePickerController = UIImagePickerController()
    private var selectedProfileImg: UIImage? = nil
    
    private var placeholder: Dictionary<String, String> = [:]
    
    @IBOutlet weak var userEmailLabel: UILabel!
    
    @IBOutlet weak var profileImageButton: UIButton!
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
        setup()
        setupNavigationBarLayout()
        setupLayout()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapSelectPicButton(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setup() {
        placeholder["storeIntroTextView"] = "간단히 가게를 소개해주세요. (최대 100자)"
        placeholder["bAddressTextView"] = "사업자등록증에 표기된 사업자주소를  입력해주세요."
        storeIntroTextView.delegate = self
        bAddressTextView.delegate = self
    }
    
    private func setupLayout() {
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
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
            $0?.textColor = .lightGray
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
extension SellerProfileSetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedProfileImg = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedProfileImg = originalImage
        }
        
        print(selectedProfileImg)

        selectedProfileImg = selectedProfileImg?.resized(toWidth: profileImageButton.frame.width)
        profileImageButton.backgroundColor = .clear
        profileImageButton.setImage(selectedProfileImg, for: .normal)

        print(profileImageButton.backgroundImage(for: .normal))
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Extensions
extension SellerProfileSetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            switch textView {
            case storeIntroTextView:
                textView.text = placeholder["storeIntroTextView"]
            case bAddressTextView:
                textView.text = placeholder["bAddressTextView"]
            default:
                textView.text = ""
            }
        }
    }
}
