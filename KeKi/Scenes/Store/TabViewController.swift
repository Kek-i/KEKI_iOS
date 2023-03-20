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
import Alamofire


class TabViewController : TabmanViewController {

    private var viewControllers: Array<UIViewController> = []
    
    private var storeIdx: Int = -1
    
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
    func initChildVC(storeIdx: Int) {
        let queryParam: Parameters = ["storeIdx" : storeIdx]
        
        let storeImageCV = viewControllers[0] as! StoreImageViewController
        let storeProductCV = viewControllers[1] as! StoreProductViewController
        
        
        APIManeger.shared.testGetData(urlEndpointString: "/posts", dataType: SearchResultResponse.self, parameter: queryParam) { response in
            storeImageCV.configure(feeds: response.result.feeds!, storeIdx: storeIdx, cursorIdx: response.result.cursorIdx!, hasNext: response.result.hasNext)
        }
        
        APIManeger.shared.testGetData(urlEndpointString: "/desserts", dataType: ProductResponse.self, parameter: queryParam) { response in
            storeProductCV.configure(desserts: response.result!.desserts, storeIdx: storeIdx, cursorIdx: response.result!.cursorIdx, hasNext: response.result!.hasNext)
        }
    }
}

