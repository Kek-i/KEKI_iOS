//
//  AuthorityGuidanceViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/30.
//

import UIKit

class AuthorityGuidanceViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var comfirmButton: UIButton!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapComfirmButton(_ sender: UIButton) { dismiss(animated: true) }
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupLayout() {
        popupView.layer.cornerRadius = 10
        comfirmButton.layer.cornerRadius = 20
    }
}

// MARK: - Extensions
