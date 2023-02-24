//
//  FeedAddViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/23.
//

import UIKit
import BSImagePicker
import Photos

enum ProductType: String {
    case cake = "케이크"
    case tarte = "타르트"
    case cookies = "쿠키"
    case none = "제품 선택"
}


class FeedAddViewController: UIViewController {

    @IBOutlet weak var imageAddCV: UICollectionView!
    
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var productTypeSelectButton: UIButton!
    @IBOutlet weak var cakeButton: UIButton!
    @IBOutlet weak var tarteButton: UIButton!
    @IBOutlet weak var cookiesButton: UIButton!
    
    @IBOutlet weak var selectButtonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var productContentTextView: UITextView!
    
    @IBOutlet weak var hashTagCV: UICollectionView!
    
    let imagePickerController = ImagePickerController()
    
    var productType: ProductType = .none
    
    var imageList: Array<UIImage> = []
    var hashTagList: Array<(String, Bool)> = []
    
    let colorList: Array<UIColor> = [
        UIColor(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 223.0 / 255.0, alpha: 1),
        UIColor(red: 250.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1),
        UIColor(red: 244.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
    ]
    
    var selectHashTagCount = 0
    
    var isOpenSelectView = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupTextViewPlaceholder()
        setupNavigationBar()
        fetchHashTagList()
    }
    
    func setup() {
        var tag = 1
        [imageAddCV, hashTagCV].forEach { cv in
            cv?.tag = tag
            cv?.dataSource = self
            cv?.delegate = self
            
            tag += 1
        }
        productContentTextView.delegate = self
        
   
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        imageAddCV.collectionViewLayout = flowLayout
        imageAddCV.showsHorizontalScrollIndicator = false
        
    }
    
    func setupLayout() {
        [selectButtonView, productContentTextView].forEach {
            $0?.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
            $0?.layer.shadowOffset = CGSize(width: 3, height: 3)
            $0?.layer.shadowRadius = 13
            $0?.layer.shadowOpacity = 1.0
            $0?.layer.cornerRadius = 10
        }
        
        [productTypeSelectButton, cakeButton, tarteButton, cookiesButton].forEach {
            $0.contentHorizontalAlignment = .left
        }
        
        productTypeSelectButton.setTitle(productType.rawValue, for: .normal)
        productTypeSelectButton.setImage(UIImage(named: "downButton"), for: .normal)
        cakeButton.setTitle(ProductType.cake.rawValue, for: .normal)
        tarteButton.setTitle(ProductType.tarte.rawValue, for: .normal)
        cookiesButton.setTitle(ProductType.cookies.rawValue, for: .normal)
        
        [cakeButton, tarteButton, cookiesButton].forEach {
            $0?.isHidden = true
        }
        
        productContentTextView.layer.borderWidth = 0
        productContentTextView.textContainerInset = .init(top: 16, left: 20, bottom: 15, right: 27)
        
        selectButtonView.layer.masksToBounds = false
    }
    
    func setupTextViewPlaceholder() {
        if productContentTextView.text == "" {
            productContentTextView.text = "제품을 소개해주세요.(최대 150자)"
            productContentTextView.textColor = UIColor(red: 128.0 / 250.0, green: 128.0 / 250.0, blue: 128.0 / 250.0, alpha: 1)
        }else if productContentTextView.text == "제품을 소개해주세요.(최대 150자)"{
            productContentTextView.text = ""
            productContentTextView.textColor = .black
        }
    }
    
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(backToScene))
        backButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
        
        // action에 addDay 추가 (서버 연결 후)
        let addButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(addFeed))
        addButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func backToScene() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addFeed() {
       
    }
    
    
    @IBAction func openDayTypeView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isOpenSelectView == false {
                self.selectButtonViewHeight.priority = UILayoutPriority(100)
                [self.cakeButton, self.tarteButton, self.cookiesButton].forEach {
                    $0?.layer.isHidden = false
                }
            }else {
                self.selectButtonViewHeight.priority = UILayoutPriority(1000)
                [self.cakeButton, self.tarteButton, self.cookiesButton].forEach {
                    $0?.layer.isHidden = true
                }
            }
        }
        self.view.layoutIfNeeded()
        
        isOpenSelectView.toggle()
    }
    
    
    @IBAction func setDayType(_ sender: UIButton) {
        if sender.titleLabel?.text == ProductType.cake.rawValue {
            productType = .cake
        }else if sender.titleLabel?.text == ProductType.tarte.rawValue {
            productType = .tarte
        }else if sender.titleLabel?.text == ProductType.cookies.rawValue {
            productType = .cookies
        }
        productTypeSelectButton.setTitle(productType.rawValue, for: .normal)
    }
    
    
}


extension FeedAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 5
        }else {
            return 4
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 2 {
            return hashTagList.count / 4
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if collectionView.tag == 1 {
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
        }else {
            if let hashTag = cell as? HashTagCell {
                hashTag.backgroundColor = .white
                if hashTagList[indexPath.row + (indexPath.section * 4)].1 {
                    hashTag.backgroundColor = colorList[indexPath.row % 3]
                }
                hashTag.setHashTagLabel(hashTag: "# " + hashTagList[indexPath.row + (indexPath.section * 4)].0)
            }
        }
        return cell
    }
    
    func imageResize(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            return CGSize(width: 100, height: 100)
        }else {
            let labelTmp = UILabel()
            labelTmp.text = "# " + hashTagList[indexPath.row + (indexPath.section * 4)].0
            
            return CGSize(width: labelTmp.intrinsicContentSize.width + 20, height: 26)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 1 {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            if indexPath.row == 0 {
                selectImage()
            }
        }
        if collectionView.tag == 2 {
            if hashTagList[indexPath.row + (indexPath.section * 4)].1 {
                selectHashTagCount -= 1
                hashTagList[indexPath.row].1.toggle()
            }else {
                if selectHashTagCount > 2 {
                    return
                }
                selectHashTagCount += 1
                hashTagList[indexPath.row + (indexPath.section * 4)].1.toggle()
            }
            
            hashTagList.sort {
                $0.1 && !$1.1
            }
            
            collectionView.reloadData()
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
            self.imageAddCV.reloadData()
        }

    }
    
}

extension FeedAddViewController: UITextViewDelegate {
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


extension FeedAddViewController {
    func fetchHashTagList() {
        APIManeger.shared.getData(urlEndpointString: "/calendars/categories", dataType: HashTagListResponse.self, header: APIManeger.buyerTokenHeader, parameter: nil) { [weak self] response in
            
            response.result.forEach { hashTag in
                self?.hashTagList.append((hashTag.tagName, false))
            }
            
            self?.hashTagCV.reloadData()
        }
    }
}
