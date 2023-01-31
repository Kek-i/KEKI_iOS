//
//  SearchViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIInit()
    }
    
    func UIInit() {
        searchView.layer.cornerRadius = 23
        searchTextField.layer.cornerRadius = 23
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor(red: 224.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1)])
    }
    
}
