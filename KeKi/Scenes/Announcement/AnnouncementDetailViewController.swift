//
//  AnnouncementDetailViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

private var URL_ENDPOINT_STR = "/cs/notice/"

class AnnouncementDetailViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var index: String!

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupLayout()
        fetchData()
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupLayout() {
        containerView.layer.masksToBounds = false
        containerView.backgroundColor = .white
        containerView.layer.borderWidth = 0
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.cornerRadius = 15
        
        containerView.layer.shadowColor = UIColor(red: 152/255, green: 113/255, blue: 113/255, alpha: 1).cgColor
        containerView.layer.shadowRadius = 10
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowOpacity = 0.2
    }
}

// MARK: - Extensions
extension AnnouncementDetailViewController {
    func setIndex(index: Int) { self.index = String(index) }
    
    private func fetchData(){
        APIManeger.apiManager.getData(urlEndpointString: URL_ENDPOINT_STR + index, dataType: AnnouncementResponse.self, header: nil, completionHandler: { [weak self] response in
            print(response)
            self?.titleLabel.text = response.result.noticeTitle
            self?.detailTextView.text = response.result.noticeContent
        })
    }
}
