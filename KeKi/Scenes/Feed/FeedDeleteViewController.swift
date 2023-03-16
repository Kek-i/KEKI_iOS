//
//  FeedDeleteViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/03/16.
//

import UIKit

class FeedDeleteViewController: UIViewController {
    
    @IBOutlet weak var deletePopView: UIView!
    @IBOutlet weak var deleteCheckLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var dessertIdx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupLayout() {
        deletePopView.layer.cornerRadius = 20
        deletePopView.layer.shadowColor = CGColor(red: 15.0 / 255.0, green: 41.0 / 255.0, blue: 107.0 / 255.0, alpha: 0.16)
        deletePopView.layer.shadowOffset = CGSize(width: 0, height: 10)
        deletePopView.layer.shadowRadius = 30
        deletePopView.layer.shadowOpacity = 1.0
        
        
        [cancelButton, deleteButton].forEach {
            $0?.layer.cornerRadius = 10
        }
    }
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteFeed(_ sender: Any) {
        requestDeleteFeed()
    }
}


extension FeedDeleteViewController {
    func requestDeleteFeed() {
        APIManeger.shared.testDeleteData(urlEndpointString: "/desserts/\(dessertIdx)") { [weak self] response in
            if response.isSuccess! {
                self?.dismiss(animated: true)
            }
        }
    }
}
