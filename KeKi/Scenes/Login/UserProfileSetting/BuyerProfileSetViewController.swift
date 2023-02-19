//
//  BuyerProfileSetViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

private let NICKNAME_VALIDATION_ENDPOINT = "/users/nickname"
private let SIGNUP_ENDPOINT = "/users/signup"
private let BUYER_EDIT_PROFILE_ENDPOINT = "/users/profile"

class BuyerProfileSetViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var navigationBackItemTitle: String? = nil
    private var isValidNickname: Bool = false
    private var validNickname: String? = nil
    private var selectedProfileImg: UIImage? = nil
    private var savedProfileImgUrl: String? = nil
    
    let imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var validateNicknameButton: UIButton!
    @IBOutlet weak var isValidNicknameLabel: UILabel!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarLayout()
        setupLayout()
        configure()
        setup()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapSelectPictureButton(_ sender: UIButton) {
        // TODO: 사진 저장공간으로 접근 처리 (임시 구현)
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    @IBAction func didTapvVlidateNicknameButton(_ sender: UIButton) { checkNicknameValidation() }
    
    // MARK: - Helper Methods (Setup Method, ...)    
    private func configure() {
        // TODO: 소셜로그인을 통해 받아온 유저의 이메일을 label값으로 보이기
        let email = UserDefaults.standard.value(forKey: "socialEmail") as! String
        userEmailLabel.text = email
        
        if APIManeger.shared.getHeader() != nil {
            // 로그인한 유저일 경우 저장된 정보 불러오기(닉네임, 프로필 사진)
            fetchData()
        }
    }
    
    private func setup() {
        imagePickerController.delegate = self
    }
    
    private func setupNavigationBarLayout() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(confirmProfileSetting))
    }
    
    private func setupLayout() {
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
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
        if APIManeger.shared.getHeader() != nil { editProfile() }
        else { signup() }
    }
}

// MARK: - Extensions
extension BuyerProfileSetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // 사진 선택
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage { selectedProfileImg = editedImage }
        else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage { selectedProfileImg = originalImage }
        
        // 버튼의 이미지를 선택된 이미지로 변경
        selectedProfileImg = selectedProfileImg?.resized(toWidth: profileImageButton.frame.width)
        profileImageButton.setImage(selectedProfileImg, for: .normal)
        
        picker.dismiss(animated: true)
    }
}

// MARK: - Extensions
extension BuyerProfileSetViewController {
    private func uploadProfileImage(image: UIImage) {
        if let userEmail = UserDefaults.standard.value(forKey: "socialEmail") {
            FirebaseStorageManager.uploadImage(image: image, pathRoot: userEmail as! String,
                                               completion: { [weak self] url in
                if let url = url { self?.savedProfileImgUrl = url.absoluteString }
            })
        }
    }
}

// MARK: - Network관련 Extensions
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
    
    private func editProfile() {
        if let nickname = nickNameTextField.text {
            
            if selectedProfileImg != nil { uploadProfileImage(image: selectedProfileImg!) }
            let editedUserInfo = Signup(nickname: nickname, profileImg: savedProfileImgUrl ?? "")
            editProfileRequest(param: editedUserInfo)
            
        } else { showAlert(message: "닉네임을 입력해주세요") }
    }
    
    // MARK: 기본 구성 헤더를 사용한 Request 메소드 사용 예시
    private func editProfileRequest(param: Signup) {
        APIManeger.shared.testPatchData(urlEndpointString: BUYER_EDIT_PROFILE_ENDPOINT,
                                   dataType: Signup.self,
                                   parameter: param,
                                   completionHandler: { [weak self] response in
            switch response.code {
            case 1000:
                print("구매자 프로필 수정 성공")
                self?.navigationController?.popToRootViewController(animated: true)
                
            default:
                print("구매자 프로필 수정 실패 :: \(response)")
                self?.showAlert(message: "네트워크 오류로 인해 프로필 수정에 실패하였습니다.")
            }
        })
    }
    
    private func signup() {
        if let nickname = nickNameTextField.text {
            
            if selectedProfileImg != nil { uploadProfileImage(image: selectedProfileImg!) }
            let signupInfo = Signup(nickname: nickname, profileImg: savedProfileImgUrl ?? "")
            signupRequest(param: signupInfo)
            
        } else { showAlert(message: "닉네임을 입력해주세요") }
    }
    
    private func signupRequest(param: Signup) {
        APIManeger.shared.postSignup(urlEndpointString: SIGNUP_ENDPOINT,
                                   dataType: Signup.self,
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
    }

}

extension BuyerProfileSetViewController {
    private func fetchData() {
        APIManeger.shared.testGetData(urlEndpointString: BUYER_EDIT_PROFILE_ENDPOINT,
                                      dataType: ProfileResponse.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in
            
            switch response.code {
            case 1000:
                self?.nickNameTextField.text = response.result.nickname
                let profileImgUrl = response.result.profileImg
                // TODO: 프로필 사진 불러오기
            default:
                print("ERROR: \(response.message)")
            }
                
            
        })
    }
}
