//
//  SelectUserCategoryViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

class SelectUserCategoryViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var selectedResult: String? = nil
    
    @IBOutlet weak var buyerButton: UIButton!
    @IBOutlet weak var sellerButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapBuyerButton(_ sender: UIButton) {
        selectedResult = "buyer"
    }
    
    @IBAction func didTapSellerButton(_ sender: UIButton) {
        selectedResult = "seller"
    }
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        if let selectedResult = selectedResult {
            print(selectedResult)   // test print
            if selectedResult == "buyer" {
                // TODO: 구매자 프로필 화면으로 전환 구현
                let storyboard = UIStoryboard(name: "UserProfileSetting", bundle: nil)
                guard let buyerProfileSetViewController = storyboard.instantiateViewController(withIdentifier: "BuyerProfileSetViewController") as? BuyerProfileSetViewController else { return }
                buyerProfileSetViewController.navigationBackItemTitle = "이전"
                navigationController?.pushViewController(buyerProfileSetViewController, animated: true)
                
            } else if selectedResult == "seller" {
                // TODO: 판매자 프로필 화면으로 전환 구현
            }
        }
    }
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupLayout() {
        [buyerButton, sellerButton].forEach { $0?.configuration?.imagePadding = 20 }
        confirmButton.layer.cornerRadius = 25
    }
}

// MARK: - Extensions
