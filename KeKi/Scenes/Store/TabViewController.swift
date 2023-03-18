//
//  TabViewContrller.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import Foundation
import Tabman
import Pageboy
import UIKit


class TabViewController : TabmanViewController {

    private var viewControllers: Array<UIViewController> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    func setup(){
        guard let storeImageVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreImageViewController") as? StoreImageViewController else {return}
        
        guard let storeProductVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreProductViewController") as? StoreProductViewController else {return}
        
        viewControllers.append(storeImageVC)
        viewControllers.append(storeProductVC)
        
        self.dataSource = self
    }
    
    func setupLayout() {
        let bar = TMBarView<TMHorizontalBarLayout, TMTabItemBarButton, TMLineBarIndicator>()
        
        
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        bar.layout.interButtonSpacing = 122
        
        bar.buttons.customize { button in
            button.imageViewSize = CGSize(width: 22, height: 22)
        }
        
        bar.backgroundView.style = .blur(style: .light)
        
        bar.indicator.cornerStyle = .rounded
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = UIColor(red: 201.0 / 255.0, green: 83.0 / 255.0, blue: 107.0 / 255.0, alpha: 1)
        
        addBar(bar, dataSource: self, at: .top)
    }
    
    func setDelegate(storeVC: StoreViewController) { storeVC.delegate = self }
}

extension TabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        let item = TMBarItem(title: "")
        
        if index == 0 {
            item.image = UIImage(named: "main")
            item.selectedImage = UIImage(named: "selected-main")
        }else{
            item.image = UIImage(named: "product")
            item.selectedImage = UIImage(named: "selected-product")
        }
        
        return item
    }
}

extension TabViewController: TabDelegate {
    func setStoreIdx(storeIdx: Int) {
        guard let feedVC = viewControllers[0] as? StoreImageViewController else {return}
        guard let productVC = viewControllers[1] as? StoreProductViewController else {return}
        
        feedVC.storeIdx = storeIdx
        productVC.storeIdx = storeIdx
    }
}

