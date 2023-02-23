//
//  StoreViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit
import Kingfisher

class StoreViewController: UIViewController {
    
    var storeIdx: Int?
    var storeInfo: Store?
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var storeImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupLayout()
    }
    
    func setupLayout() {
        navigationController?.navigationBar.isHidden = true

        storeImageView.layer.cornerRadius = 40
        
        orderButton.layer.cornerRadius = 10
        orderButton.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
        orderButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        orderButton.layer.shadowRadius = 13
        orderButton.layer.shadowOpacity = 1.0
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
        APIManeger.shared.testGetData(urlEndpointString: "/stores/profile/\(storeIdx!)",
                                      dataType: StoreResponse.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in
            self?.storeInfo = response.result
            self?.configure()
        })
    }
    
    private func configure() {
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
