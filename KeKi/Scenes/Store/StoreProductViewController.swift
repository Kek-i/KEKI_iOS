//
//  StoreProductViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import UIKit
import Alamofire

class StoreProductViewController: UIViewController {

    @IBOutlet weak var storeProductCV: UICollectionView!
    @IBOutlet weak var productAddButton: UIButton!
    
    
    var storeIdx: Int = -1
    var desserts: Array<Dessert> = []
    var queryParam: Parameters = [:]
    
    
    var cursorIdx: Int?
    var hasNext: Bool?
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    func setup() {
        storeProductCV.delegate = self
        storeProductCV.dataSource = self
    }
    
    func setupLayout() {
        if APIManeger.shared.getHeader() == nil {
            productAddButton.layer.isHidden = true
            return
        }else {
            if APIManeger.shared.getUserInfo()?.role == "판매자" {
                productAddButton.layer.cornerRadius = 25
                
                productAddButton.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
                productAddButton.layer.shadowOffset = CGSize(width: 0, height: 3)
                productAddButton.layer.shadowRadius = 6
                productAddButton.layer.shadowOpacity = 1.0
                
            }else {
                productAddButton.layer.isHidden = true
            }
        }
    }

    func configure(desserts: [Dessert], storeIdx: Int, cursorIdx: Int, hasNext: Bool) {
        self.desserts = desserts
        self.storeIdx = storeIdx
        self.cursorIdx = cursorIdx
        self.hasNext = hasNext
        storeProductCV?.reloadData()
    }
    
    @IBAction func productAdd(_ sender: Any) {
        guard let productAddView = UIStoryboard(name: "ProductAdd", bundle: nil).instantiateViewController(withIdentifier: "ProductAddViewController") as? ProductAddViewController else {return}
        
        
        productAddView.modalTransitionStyle = .coverVertical
        productAddView.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(productAddView, animated: true)
    }
}

extension StoreProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return desserts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreImageCell", for: indexPath) as? StoreImageCell else { return UICollectionViewCell() }
        
        let url = desserts[indexPath.row].dessertImgUrl
        cell.storeImageView.kf.setImage(with: URL(string: url))
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if storeProductCV.contentOffset.y > storeProductCV.contentSize.height-storeProductCV.bounds.size.height && self.hasNext == true{
            setQueryParam(storeIdx: self.storeIdx, cursorIdx: self.cursorIdx)
            isLoading = true
        }
    }
}

extension StoreProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 20) / 3 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: 선택된 dessert의 상품 상세 화면으로 이동
        let storyboard = UIStoryboard.init(name: "ProductDetail", bundle: nil)
        guard let productViewController = storyboard.instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else { return }
        
        productViewController.dessertIdx = desserts[indexPath.row].dessertIdx
        
        productViewController.modalTransitionStyle = .coverVertical
        productViewController.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(productViewController, animated: true)
       
    }
}

extension StoreProductViewController {
    func setQueryParam(storeIdx: Int?, cursorIdx: Int?) {
        if isLoading == true {
            return
        }
        
        queryParam["storeIdx"] = storeIdx
        queryParam["cursorIdx"] = cursorIdx
        
        getProductList(queryParam: queryParam)
    }
    
    
    func getProductList(queryParam: Parameters) {
        APIManeger.shared.testGetData(urlEndpointString: "/desserts", dataType: ProductResponse.self, parameter: queryParam) { [weak self] response in
            
            self?.hasNext = response.result?.hasNext
            self?.cursorIdx = response.result?.cursorIdx
            
            response.result?.desserts.forEach({ dessert in
                self?.desserts.append(dessert)
            })
            
            self?.storeProductCV.reloadData()
            
            self?.isLoading = false
        }
    }
}
