//
//  StoreInfoPopUpViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class StoreInfoPopUpViewController: UIViewController {

    @IBOutlet var selfView: UIView!
    
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storeNum: UILabel!
    
    var sellerInfo: SellerInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sellerName.text = sellerInfo?.businessName
        storeName.text = sellerInfo?.brandName
        storeAddress.text = sellerInfo?.businessAddress
        storeNum.text = sellerInfo?.businessNumber
    }
    
    func setup() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))

        selfView.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}
