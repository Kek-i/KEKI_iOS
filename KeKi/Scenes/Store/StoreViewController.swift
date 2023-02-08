//
//  StoreViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

class StoreViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var storeImageView: UIImageView!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
    
    func setupLayout() {
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
    
}
