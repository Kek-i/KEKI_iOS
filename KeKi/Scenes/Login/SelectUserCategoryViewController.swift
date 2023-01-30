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
        buyerButton.isSelected = !buyerButton.isSelected
        setButtonBySelectStatus(buyerButton)
        if (sellerButton.isSelected) && (buyerButton.isSelected) { didTapSellerButton(sellerButton) }
    }
    
    @IBAction func didTapSellerButton(_ sender: UIButton) {
        sellerButton.isSelected = !sellerButton.isSelected
        setButtonBySelectStatus(sellerButton)
        if (buyerButton.isSelected) && (sellerButton.isSelected) { didTapBuyerButton(buyerButton) }
    }
    
    @IBAction func didTapConfirmButton(_ sender: UIButton) {
        let backItem = UIBarButtonItem()
        backItem.title = "가입자 선택"
        navigationItem.backBarButtonItem = backItem
        
        if buyerButton.isSelected {
            // TODO: 구매자 프로필 화면으로 전환 구현
            let storyboard = UIStoryboard(name: "UserProfileSetting", bundle: nil)
            guard let buyerProfileSetViewController = storyboard.instantiateViewController(withIdentifier: "BuyerProfileSetViewController") as? BuyerProfileSetViewController else { return }
            navigationController?.pushViewController(buyerProfileSetViewController, animated: true)
            
        } else if sellerButton.isSelected {
            // TODO: 판매자 프로필 화면으로 전환 구현
            let storyboard = UIStoryboard(name: "UserProfileSetting", bundle: nil)
            guard let sellerProfileSetViewController = storyboard.instantiateViewController(withIdentifier: "SellerProfileSetViewController") as? SellerProfileSetViewController else { return }
            navigationController?.pushViewController(sellerProfileSetViewController, animated: true)
        }
    }
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupLayout() {
        [buyerButton, sellerButton].forEach {
            $0?.configuration?.imagePadding = 20
            $0?.imageView?.layer.cornerRadius = ($0?.frame.width ?? 0)/2
        }
        confirmButton.layer.cornerRadius = 25
    }
    
    private func setButtonBySelectStatus(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = UIColor.white
            button.imageView?.layer.borderColor = UIColor(red: 209/255, green: 108/255, blue: 139/255, alpha: 1).cgColor
            button.imageView?.layer.borderWidth = 3.0
        } else {
            button.backgroundColor = .white
            button.imageView?.layer.borderColor = .none
            button.imageView?.layer.borderWidth = 0
        }
        button.backgroundColor = .white
    }
}

// MARK: - Extensions
