//
//  ProductAddViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/24.
//

import UIKit
import BSImagePicker
import Photos

class ProductAddViewController: UIViewController {

    
    @IBOutlet weak var productTitleTF: UITextField!
    @IBOutlet weak var productPriceTF: UITextField!
    @IBOutlet weak var productContentTV: UITextView!
    
    @IBOutlet weak var productImageCV: UICollectionView!
    
    let imagePickerController = ImagePickerController()
    
    var selectedImage: UIImage?
    var selectedImageUrl: String?
    
    var dessertIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        setupNavigationBar()
        setupTextViewPlaceholder()
        
        dessertIdx = 2
        
        if dessertIdx != nil {
            fetchProductEdit(dessertIdx: dessertIdx!)
        }
        
    }
    
    func setup() {
        productImageCV.delegate = self
        productImageCV.dataSource = self
        productContentTV.delegate = self
    }
    
    func setupLayout() {
        [productTitleTF, productPriceTF].forEach { textField in
            textField.layer.borderWidth = 0
            textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            textField.leftViewMode = .always
            textField.addLeftPadding()
        }
        
        [productTitleTF, productPriceTF, productContentTV].forEach {
            $0?.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
            $0?.layer.shadowOffset = CGSize(width: 3, height: 3)
            $0?.layer.shadowRadius = 13
            $0?.layer.shadowOpacity = 1.0
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 0
            $0?.layer.masksToBounds = false
        }
       
        
        setupTextFieldPlaceholder(textField: productTitleTF, placeholder: "상품 이름을 입력해주세요.")
        setupTextFieldPlaceholder(textField: productPriceTF, placeholder: "상품 가격을 입력해주세요.")
        
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        productImageCV.collectionViewLayout = flowLayout
        productImageCV.showsHorizontalScrollIndicator = false
        
        productContentTV.font = UIFont.systemFont(ofSize: 16)
        productContentTV.layer.borderWidth = 0
        productContentTV.textContainerInset = .init(top: 16, left: 20, bottom: 15, right: 27)
    }
    
    func setupTextFieldPlaceholder(textField: UITextField, placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 128.0 / 250.0, green: 128.0 / 250.0, blue: 128.0 / 250.0, alpha: 1)])
    }
    
    func setupTextViewPlaceholder() {
        if productContentTV.text == "" {
            productContentTV.text = "제품을 소개해주세요.(최대 150자)"
            productContentTV.textColor = UIColor(red: 128.0 / 250.0, green: 128.0 / 250.0, blue: 128.0 / 250.0, alpha: 1)
        }else if productContentTV.text == "제품을 소개해주세요.(최대 150자)"{
            productContentTV.text = ""
            productContentTV.textColor = .black
        }
    }
    
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(backToScene))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
        
        // action에 addDay 추가 (서버 연결 후)
        let addButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addProduct))
        addButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func backToScene() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addProduct() {
        if productTitleTF.text == nil || productTitleTF.text == "" {
            showAlert(title: "상품 이름 입력", message: "상품의 이름을 입력해주세요.")
            return
        }
        
        if productPriceTF.text == nil || productPriceTF.text == "" {
            showAlert(title: "상품 가격 입력", message: "상품의 가격을 입력해주세요.")
            return
        }
        
        if productContentTV.text == nil || productContentTV.text == "" || productTitleTF.text == "제품을 소개해주세요.(최대 150자)"{
            showAlert(title: "제품 소개란 입력", message: "제품의 소개란을 입력해주세요.")
            return
        }
        
        if selectedImage == nil {
            showAlert(title: "상품 대표사진 추가", message: "상품의 대표사진을 추가해주세요.")
            return
        }
        
        let desertName = productTitleTF.text!
        let desertPrice = productPriceTF.text!
        let dessertDescription = productContentTV.text!
        
        uploadImages {
            if self.dessertIdx != nil {
                self.requestEditProduct(dessertIdx: self.dessertIdx ?? 0, dessertName: desertName, desertPrice: desertPrice, dessertDescription: dessertDescription, dessertImg: self.selectedImageUrl!)
            }else {
                self.requestAddProduct(dessertName: desertName, desertPrice: desertPrice, dessertDescription: dessertDescription, dessertImg: self.selectedImageUrl!)
            }
        }
        
        
    }
    

    
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}


extension ProductAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let imageCell = cell as? ImageCell {
            if indexPath.row == 0 {
                guard let image = UIImage(named: "imagePlus") else {return cell}
                imageCell.productImage.contentMode = .center
                imageCell.productImage.image = image
            }else {
                if selectedImage != nil {
                    imageCell.productImage.image = selectedImage
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectImage()
        }
    }
    
    func selectImage() {
        imagePickerController.settings.selection.max = 1
        imagePickerController.settings.fetch.assets.supportedMediaTypes = [.image]
        
        self.presentImagePicker(imagePickerController) { (asset) in
            
        } deselect: { (asset) in
            
        } cancel: { (assets) in
            
        } finish: { (assets) in
            let imageManager = PHImageManager.default()
            let option = PHImageRequestOptions()
            option.isSynchronous = true
            
            assets.forEach { asset in
                var thumbnail = UIImage()
                
                imageManager.requestImage(for: asset,
                                          targetSize: CGSize(width: 100, height: 200),
                                          contentMode: .aspectFit,
                                          options: option) { (result, info) in
                    thumbnail = result!
                }
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                self.selectedImage = UIImage(data: data!)
            }
            self.productImageCV.reloadData()
        }

    }
}

extension ProductAddViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setupTextViewPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setupTextViewPlaceholder()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let textRange = Range(range, in: currentText) else {return false}
        
        let changedText = currentText.replacingCharacters(in: textRange, with: text)
        
        return changedText.count <= 150
    }
}

extension ProductAddViewController {
    func fetchProductEdit(dessertIdx: Int) {
        APIManeger.shared.getData(urlEndpointString: "/desserts/\(dessertIdx)/editDessert", dataType: ProductEditResponse.self, header: APIManeger.sellerTokenHeader, parameter: nil) { [weak self] response in
            
            self?.productTitleTF.text = response.result.dessertName
            self?.productPriceTF.text = response.result.dessertPrice.description
            self?.productContentTV.text = response.result.dessertDescription
            self?.selectedImageUrl = response.result.dessertImg
            
            if let imageUrl = URL(string: response.result.dessertImg) {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    self?.selectedImage = UIImage(data: imageData)!
                }
            }
            
            self?.productContentTV.textColor = .black
            
            self?.productImageCV.reloadData()
        }
    }
    
    func uploadImages(completionHanlder: @escaping () -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd_HHmmssss"
        let pathRoot = dateFormatter.string(from: Date())

        FirebaseStorageManager.uploadImage(image: selectedImage!, pathRoot: pathRoot,
                                                    folderName: FirebaseStorageManager.productFolder
                                                    ,completion: { [weak self] url in
            self?.selectedImageUrl = url?.description
            completionHanlder()
        })
    }

    func requestAddProduct(dessertName: String, desertPrice: String, dessertDescription: String, dessertImg: String) {
        let param = ProductRequest(dessertName: dessertName, dessertPrice: desertPrice, dessertDescription: dessertDescription, dessertImg: dessertImg)
        APIManeger.shared.postData(urlEndpointString: "/desserts", dataType: ProductRequest.self, header: APIManeger.sellerTokenHeader, parameter: param) { [weak self] response in
            // 나중에 화면 바뀌도록 바꾸기
            print(response)
            self?.showAlert(title: "성공", message: "상품 추가 성공")
        }
    }
    
    func requestEditProduct(dessertIdx: Int, dessertName: String, desertPrice: String, dessertDescription: String, dessertImg: String) {
        let param = ProductRequest(dessertName: dessertName, dessertPrice: desertPrice, dessertDescription: dessertDescription, dessertImg: dessertImg)
        APIManeger.shared.patchData(urlEndpointString: "/desserts/\(dessertIdx)", dataType: ProductRequest.self, header: APIManeger.sellerTokenHeader, parameter: param) { [weak self] response in
            // 나중에 화면 바뀌도록 바꾸기
            print(response)
            self?.showAlert(title: "성공", message: "상품 수정 성공")
        }
    }
}

