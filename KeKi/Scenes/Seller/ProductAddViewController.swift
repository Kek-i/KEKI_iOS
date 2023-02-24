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
    
    var imageList: Array<UIImage> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
        setupNavigationBar()
        setupTextViewPlaceholder()
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
}


extension ProductAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if let imageCell = cell as? ImageCell {
            if indexPath.row == 0 {
                guard let image = UIImage(named: "imagePlus") else {return cell}
                imageCell.productImage.contentMode = .center
                imageCell.productImage.image = image
            }else {
                if imageList.count != 0 {
                    imageCell.productImage.image = imageList[indexPath.row-1]
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
        imagePickerController.settings.selection.max = 4
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
                guard let newImage = UIImage(data: data!) else {return}
                
                self.imageList.append(newImage)
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

