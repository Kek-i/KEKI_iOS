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
    
    var searchMainVC: SearchMainViewController?
    var searchNothingVC: SearchNothingViewController?
    var searchDetailVC: SearchDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        UIInit()
    }
    
    func setup() {
        searchTextField.delegate = self
        
        guard let searchMainVC = UIStoryboard(name: "SearchMainViewController", bundle: nil).instantiateViewController(withIdentifier: "SearchMainViewController") as? SearchMainViewController else {return}
        
        containerView.addSubview(searchMainVC.view)
        searchMainVC.didMove(toParent: self)
        self.addChild(searchMainVC)
        
        self.searchMainVC = searchMainVC
    }
    
    func UIInit() {
        searchView.layer.cornerRadius = 23
        searchTextField.layer.cornerRadius = 23
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor(red: 224.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1)])
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        search(text: textField.text)
        
        return true
    } 
    func search(text: String?){
        // 검색
        
        // 임시로 text가 비어있으면 검색결과 없음으로 표시
        if text == nil || text == "" {
            guard let searchNothingVC = UIStoryboard(name: "SearchNothingViewController", bundle: nil).instantiateViewController(withIdentifier: "SearchNothingViewController") as? SearchNothingViewController else {return}
            
            self.searchMainVC?.view.removeFromSuperview()
            
            containerView.addSubview(searchNothingVC.view)
            searchNothingVC.didMove(toParent: self)
            self.addChild(searchNothingVC)
            
            self.searchNothingVC = searchNothingVC
        }else {
            guard let searchDetailVC = UIStoryboard(name: "SearchDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "SearchDetailViewController") as? SearchDetailViewController else {return}
            
            self.searchMainVC?.view.removeFromSuperview()
            
            containerView.addSubview(searchDetailVC.view)
            searchDetailVC.didMove(toParent: self)
            self.addChild(searchDetailVC)
            
            self.searchDetailVC = searchDetailVC
        }
    }
}
