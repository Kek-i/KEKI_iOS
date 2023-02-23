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
    
    var delegate: TabDelegate!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var storeImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var orderButton: UIButton!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embedContainer" {
            let tabVC = segue.destination as! TabViewController
            tabVC.setDelegate(storeVC: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupLayout() {
        storeImageView.layer.cornerRadius = 40
        
        orderButton.layer.cornerRadius = 10
        orderButton.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
        orderButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        orderButton.layer.shadowRadius = 13
        orderButton.layer.shadowOpacity = 1.0
    }

    @IBAction func didTapBackItem(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showInfoPopUp(_ sender: Any) {
        guard let infoPopUpVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreInfoPopUpViewController") as? StoreInfoPopUpViewController else {return}
        
        infoPopUpVC.modalTransitionStyle = .coverVertical
        infoPopUpVC.modalPresentationStyle = .overCurrentContext
        
        self.present(infoPopUpVC, animated: true)
    }
    
    @IBAction func didTapOrderButton(_ sender: UIButton) {
        // TODO: 주문 링크로 접속 (웹뷰 사용?)
    }
    
    private func fetchData() {
        // 스토어 정보 fetch
        APIManeger.shared.testGetData(urlEndpointString: "/stores/profile/\(storeIdx!)",
                                      dataType: StoreResponse.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in
            
            self?.storeInfo = response.result
            self?.configureProfile()
        })
        
        // 스토어 피드 & 상품 정보 fetch
        delegate.configureFeedTab(storeIdx: storeIdx!)
        delegate.configureProductTab(storeIdx: storeIdx!)

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
