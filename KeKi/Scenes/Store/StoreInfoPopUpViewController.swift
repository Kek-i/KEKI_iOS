//
//  StoreInfoPopUpViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class StoreInfoPopUpViewController: UIViewController {

    @IBOutlet var selfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

                
        selfView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}
