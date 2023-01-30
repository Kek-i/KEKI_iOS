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
        
        tabmanInit()
    }
    
    func tabmanInit(){
        guard let storeImageVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreImageViewController") as? StoreImageViewController else {return}
        
        guard let storeProductVC = self.storyboard?.instantiateViewController(withIdentifier: "StoreProductViewController") as? StoreProductViewController else {return}
        
        viewControllers.append(storeImageVC)
        viewControllers.append(storeProductVC)
        
        self.dataSource = self
        
        let bar = TMBar.TabBar()
        bar.layout.transitionStyle = .snap
        
        bar.backgroundView.style = .blur(style: .light)
        
        bar.indicator.tintColor = UIColor(red: 248, green: 236, blue: 236, alpha: 0)
        
    
        
        addBar(bar, dataSource: self, at: .top)
        
    }
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
