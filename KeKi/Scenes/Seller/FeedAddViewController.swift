//
//  FeedAddViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/23.
//

import UIKit
import BSImagePicker
import Photos


class FeedAddViewController: UIViewController {

    @IBOutlet weak var imageAddCV: UICollectionView!
    
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var productTypeSelectButton: UIButton!
    @IBOutlet weak var productTypeTableView: UITableView!
    
    @IBOutlet weak var selectButtonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var productContentTextView: UITextView!
    
    @IBOutlet weak var hashTagCV: UICollectionView!
    
    let imagePickerController = ImagePickerController()
    
    var productType = "제품 선택"
    
    var imageList: Array<UIImage> = []
    var hashTagList: Array<(String, Bool)> = []
    
    var desertInfoList: Array<DessertInfo> = []
    
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
        fetchFeedAddInfo()
    }
    
    func setup() {
        var tag = 1
        [imageAddCV, hashTagCV].forEach { cv in
            cv?.tag = tag
            cv?.dataSource = self
            cv?.delegate = self
            
            tag += 1
        }
        productTypeTableView.dataSource = self
        productTypeTableView.delegate = self
        
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
        
        productTypeSelectButton.contentHorizontalAlignment = .left
        productTypeSelectButton.setTitle(productType, for: .normal)
        productTypeSelectButton.setImage(UIImage(named: "downButton"), for: .normal)
        
        selectButtonViewHeight.priority = UILayoutPriority(1000)
        
        productTypeTableView.isHidden = true
        productTypeTableView.separatorStyle = .none
        productTypeTableView.rowHeight = 25
        
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
        var hashTags: [String] = []
        hashTagList.forEach {
            if $0.1 == true {
                hashTags.append($0.0)
                print(hashTags.count)
            }
        }
        print(hashTags)
//        requestAddFeed()
    }
    
    
    @IBAction func openProductType(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.isOpenSelectView == false {
                self.selectButtonViewHeight.priority = UILayoutPriority(100)
                self.productTypeTableView.isHidden = false
                
            }else {
                self.selectButtonViewHeight.priority = UILayoutPriority(1000)
                self.productTypeTableView.isHidden = true
            }
        }
        self.view.layoutIfNeeded()
        
        isOpenSelectView.toggle()
    }
    
}


extension FeedAddViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return 6
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
                        imageCell.productImage.contentMode = .scaleToFill
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
        if collectionView.tag == 1{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 14, right: 20)
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
        imagePickerController.settings.selection.max = 5
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

extension FeedAddViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return desertInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductSelectCell", for: indexPath)
        cell.selectionStyle = .none
        
        if let productCell = cell as? ProductSelectCell {
            if desertInfoList.count != 0 {
                productCell.setProductName(productName: desertInfoList[indexPath.row].dessertName)
            }
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        productType = desertInfoList[indexPath.row].dessertName
        productTypeSelectButton.setTitle(productType, for: .normal)
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
    func fetchFeedAddInfo() {
        APIManeger.shared.getData(urlEndpointString: "/posts/makeView", dataType: FeedAddResponse.self, header: APIManeger.sellerTokenHeader, parameter: nil) { [weak self] response in
            print(response)
            response.result.tags.forEach { hashTag in
                self?.hashTagList.append((hashTag, false))
            }
            
            self?.desertInfoList = response.result.desserts
            
            self?.hashTagCV.reloadData()
            self?.productTypeTableView.reloadData()
        }
    }
    
    func requestAddFeed(desertIdx: Int, description: String, postImgUrls: [String], tags: [String]) {
        let param = FeedAddRequest(dessertIdx: desertIdx, description: description, postImgUrls: postImgUrls, tags: tags)
        APIManeger.shared.postData(urlEndpointString: "/posts", dataType: FeedAddRequest.self, header: nil, parameter: param) { [weak self] response in
            print(response)
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
