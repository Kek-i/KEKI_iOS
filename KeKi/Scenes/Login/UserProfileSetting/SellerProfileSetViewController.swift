//
//  SellerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

private let SIGNUP_ENDPOINT = "/stores/signup"

class SellerProfileSetViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private let imagePickerController = UIImagePickerController()
    private var selectedProfileImg: UIImage? = nil
    private var savedProfileImgUrl: String? = nil

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
        if APIManeger.shared.getHeader() != nil { editProfile() }
        else { signup() }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
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
        
        selectedProfileImg = selectedProfileImg?.resized(toWidth: profileImageButton.frame.width)
        profileImageButton.backgroundColor = .clear
        profileImageButton.setImage(selectedProfileImg, for: .normal)
        
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

// MARK: - Network관련 Extensions
extension SellerProfileSetViewController {
    private func uploadProfileImage(image: UIImage, completionHandler: @escaping ()-> Void) {
        if let userEmail = UserDefaults.standard.value(forKey: "socialEmail") {
            FirebaseStorageManager.uploadImage(image: image, pathRoot: userEmail as! String,
                                               completion: { [weak self] url in
                if let url = url {
                    self?.savedProfileImgUrl = url.absoluteString
                    completionHandler()
                }
            })
        }
    }
    
    private func setSellerInfo() -> Seller {
        let signupInfo = Seller(storeImgUrl: savedProfileImgUrl ?? "",
                                nickname: storeNameTextField.text!,
                                address: storeAddressTextField.text ?? "",
                                orderUrl: orderLinkTextField.text ?? "",
                                businessName: bRepresentativeNameTextField.text ?? "",
                                brandName: bStoreNameTextField.text ?? "",
                                businessAddress: bAddressTextView.text ?? "",
                                businessNumber: bCompRegistNumTextField.text ?? "")
        return signupInfo
    }
    
    private func signup() {
        if let _ = storeNameTextField.text {

            if selectedProfileImg != nil {
                uploadProfileImage(image: selectedProfileImg!) { [weak self] in
                    let signupInfo = self?.setSellerInfo()
                    self?.signupRequest(param: signupInfo!)
                }
            } else {
                let signupInfo = setSellerInfo()
                signupRequest(param: signupInfo)
            }
            
        } else { showAlert(message: "가게 이름을 입력해주세요") }
    }
    
    private func signupRequest(param: Seller) {
        APIManeger.shared.postSignup(urlEndpointString: SIGNUP_ENDPOINT,
                                   dataType: Seller.self,
                                   parameter: param,
                                   completionHandler: { [weak self] response in
            switch response.code {
            case 1000:
                print("회원가입 성공")
                let userInfo = response.result
                
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
    
    private func editProfile() {
        // TODO: 판매자 프로필 편집 구현
        print("seller :: editProfile")
    }
}
