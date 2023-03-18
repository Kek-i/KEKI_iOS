//
//  StoreViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit
import Alamofire
import Kingfisher

protocol TabDelegate {
    func configureFeedTab(storeIdx: Int)
    func configureProductTab(storeIdx: Int)
}

class StoreViewController: UIViewController {
    
    var storeIdx: Int?
    var storeInfo: Store?
    var sellerInfo: SellerInfo?
    
    var delegate: TabDelegate!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var storeImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tabVC = segue.destination as! TabViewController
        tabVC.setDelegate(storeVC: self)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupLayout()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    func setupLayout() {
        storeImageView.layer.cornerRadius = 40
        
        orderButton.layer.cornerRadius = 10
        orderButton.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
        orderButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        orderButton.layer.shadowRadius = 13
        orderButton.layer.shadowOpacity = 1.0
        if APIManeger.shared.getUserInfo()?.role == "판매자" {
            orderButton.isHidden = true
    
        }
    }
    
    func setupNavigationBar() {
        if APIManeger.shared.getUserInfo()?.role == "판매자" {
            self.navigationController?.isNavigationBarHidden = true
        }else {
            self.navigationController?.isNavigationBarHidden = false
            
            let backButton = UIBarButtonItem(image: UIImage(named: "chevron-right"), style: .done, target: self, action: #selector(didTapBackItem))
            backButton.tintColor = .black
            
            let infoButton = UIBarButtonItem(image: UIImage(named: "info"), style: .done, target: self, action: #selector(showInfoPopUp))
            infoButton.tintColor = .black
            
            let messageButton = UIBarButtonItem(image: UIImage(named: "icMessage"), style: .done, target: self, action: #selector(didTapOrderButton))
            messageButton.tintColor = .black
            
            self.navigationItem.leftBarButtonItem = backButton
            self.navigationItem.rightBarButtonItems = [messageButton, infoButton]
        }
    }
    
    @objc func didTapBackItem(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showInfoPopUp() {
        fetchSellerInfo {
            guard let infoPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreInfoPopUpViewController") as? StoreInfoPopUpViewController else {return}
            
            infoPopUpVC.sellerInfo = self.sellerInfo
            
            infoPopUpVC.modalTransitionStyle = .coverVertical
            infoPopUpVC.modalPresentationStyle = .overCurrentContext
            
            self.present(infoPopUpVC, animated: true)
        }
    }
    
    @objc func didTapOrderButton(_ sender: UIButton) {
        // TODO: 주문 링크로 접속 (웹뷰 사용?)
    }
    
    
    private func configureProfile() {
        storeNameLabel.text = storeInfo?.nickname
        if let url = storeInfo?.storeImgUrl {
            storeImageView.kf.setImage(with: URL(string: url))
            storeImageView.backgroundColor = .clear
            storeImageView.layer.borderColor = UIColor.lightGray.cgColor
            storeImageView.layer.borderWidth = 0.5
        }
        storeDescriptionLabel.text = storeInfo?.introduction
    }
    
}
    
    
extension StoreViewController{
    private func fetchData() {
        // 스토어 정보 fetch
        APIManeger.shared.testGetData(urlEndpointString: "/stores/profile/\(storeIdx ?? 0)",
                                      dataType: StoreResponse.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in
            
            self?.storeInfo = response.result
            self?.configureProfile()
            self?.delegate.configureFeedTab(storeIdx: (self?.storeIdx)!)
            self?.delegate.configureProductTab(storeIdx: (self?.storeIdx)!)
        })
        
        // 스토어 피드 & 상품 정보 fetch
        
    }

    func fetchSellerInfo(completionHandler: @escaping () -> Void) {
        APIManeger.shared.testGetData(urlEndpointString: "/stores/store-info/\(storeIdx!)", dataType: SellerInfoResponse.self, parameter: nil) { [weak self] response in
            self?.sellerInfo = response.result
            completionHandler()
        }
    }
    
    
}
