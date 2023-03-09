//
//  SellerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit
import Kingfisher

private let SIGNUP_ENDPOINT = "/stores/signup"
private let SELLER_EDIT_PROFILE_ENDPOINT = "/stores/profile"

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
        tabBarController?.tabBar.isHidden = true
        setupNavigationBarLayout()
        setupLayout()
        configure()
        setup()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapSelectPicButton(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func configure() {
        let email = UserDefaults.standard.value(forKey: "socialEmail") as! String
        userEmailLabel.text = email
        if APIManeger.shared.getHeader() != nil { fetchData() }
    }
    
    private func setup() {
        placeholder["storeIntroTextView"] = "간단히 가게를 소개해주세요. (최대 100자)"
        placeholder["bAddressTextView"] = "사업자등록증에 표기된 사업자주소를  입력해주세요."
        storeIntroTextView.delegate = self
        bAddressTextView.delegate = self
        imagePickerController.delegate = self
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
            FirebaseStorageManager.uploadImage(image: image, pathRoot: userEmail as! String, folderName: FirebaseStorageManager.profileFolder,
                                               completion: { [weak self] url in
                if let url = url {
                    self?.savedProfileImgUrl = url.absoluteString
                    completionHandler()
                }
            })
        }
    }
    
    private func getSellerInfo() -> Seller {
        let sellerInfo = Seller(storeImgUrl: savedProfileImgUrl ?? "",
                                nickname: storeNameTextField.text!,
                                address: storeAddressTextField.text ?? "",
                                introduction: storeIntroTextView.text ?? "",
                                orderUrl: orderLinkTextField.text ?? "",
                                businessName: bRepresentativeNameTextField.text ?? "",
                                brandName: bStoreNameTextField.text ?? "",
                                businessAddress: bAddressTextView.text ?? "",
                                businessNumber: bCompRegistNumTextField.text ?? "")
        return sellerInfo
    }
    
    private func signup() {
        if let _ = storeNameTextField.text {

            if selectedProfileImg != nil {
                uploadProfileImage(image: selectedProfileImg!) { [weak self] in
                    let signupInfo = self?.getSellerInfo()
                    self?.signupRequest(param: signupInfo!)
                }
            } else {
                let signupInfo = getSellerInfo()
                signupRequest(param: signupInfo)
            }
            
        } else { showAlert(message: "가게 이름을 입력해주세요") }
    }
    
    private func editProfile() {
        if let _ = storeNameTextField.text {
            if selectedProfileImg != nil {
                uploadProfileImage(image: selectedProfileImg!) { [weak self] in
                    let editedUserInfo = self?.getSellerInfo()
                    self?.editProfileRequest(param: editedUserInfo!)
                }
            } else {
                let signupInfo = getSellerInfo()
                editProfileRequest(param: signupInfo)
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
    
    private func editProfileRequest(param: Seller) {
        APIManeger.shared.testPatchData(urlEndpointString: SELLER_EDIT_PROFILE_ENDPOINT,
                                   dataType: Seller.self,
                                   parameter: param,
                                   completionHandler: { [weak self] response in
            switch response.code {
            case 1000:
                print("판매자 프로필 수정 성공")
                self?.navigationController?.popToRootViewController(animated: true)
                
            default:
                print("판매자 프로필 수정 실패 :: \(response)")
                self?.showAlert(message: "네트워크 오류로 인해 프로필 수정에 실패하였습니다.")
            }
        })
    }
    
    private func fetchData() {
        APIManeger.shared.testGetData(urlEndpointString: SELLER_EDIT_PROFILE_ENDPOINT,
                                      dataType: ProfileResponse<Seller>.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in

            switch response.code {
            case 1000:
                if let result = response.result {

                    self?.storeNameTextField.text = result.nickname
                    self?.storeAddressTextField.text = result.address
                    if let _ = result.introduction {
                        self?.storeIntroTextView.text = result.introduction
                        self?.storeIntroTextView.textColor = .black
                    }
                    
                    self?.orderLinkTextField.text = result.orderUrl

                    self?.bStoreNameTextField.text = result.brandName
                    self?.bRepresentativeNameTextField.text = result.businessName
                    if let _ = result.businessAddress {
                        self?.bAddressTextView.text = result.businessAddress
                        self?.bAddressTextView.textColor = .black
                    }
                    self?.bCompRegistNumTextField.text = result.businessNumber

                    if let profileImgUrl = result.storeImgUrl {
                        let modifier = AnyImageModifier { return $0.withRenderingMode(.alwaysOriginal) }
                        self?.profileImageButton.kf.setImage(with: URL(string: profileImgUrl),
                                                             for: .normal, placeholder: nil,
                                                             options: [.imageModifier(modifier)],
                                                             progressBlock: nil, completionHandler: nil)
                    }
                }

            default:
                print("ERROR: \(response.message)")
            }
        })
    }
}
