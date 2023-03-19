//
//  DefaultTabBarController.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/02.
//

import UIKit

class DefaultTabBarController: UITabBarController {

    private let homeTab = UITabBarItem(title: nil, image: UIImage(named: "home"), selectedImage: UIImage(named: "home.fill"))
    private let calendarTab = UITabBarItem(title: nil, image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar.fill"))
    private let searchTab = UITabBarItem(title: nil, image: UIImage(named: "search"), selectedImage: UIImage(named: "search.fill"))
    private let heartTab = UITabBarItem(title: nil, image: UIImage(named: "heart"), selectedImage: UIImage(named: "heart.fill"))
    // 디자이너 선생님이 꽉찬 아이콘 보내줄시 고치기
    private let storeTab = UITabBarItem(title: nil, image: UIImage(named: "store"), selectedImage: UIImage(named: "store"))
    private let mypageTab = UITabBarItem(title: nil, image: UIImage(named: "mypage"), selectedImage: UIImage(named: "mypage.fill"))
    
    
    var storeIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        var tabFrame = tabBar.frame
        if UIDevice.hasNotch {
            tabFrame.size.height = 100
            tabFrame.origin.y = self.view.frame.size.height - 100
        } else {
            tabFrame.size.height = 60
            tabFrame.origin.y = self.view.frame.size.height - 60
        }
        tabBar.frame = tabFrame
        
        setLayoutTabBar()
    }
    
    private func setLayoutTabBar() {
        tabBar.unselectedItemTintColor = UIColor(red: 224/255, green: 187/255, blue: 187/255, alpha: 1)
        tabBar.tintColor = UIColor(red: 217/255, green: 72/255, blue: 106/255, alpha: 1)
        tabBar.barTintColor = .white
    }
    
    private func configureTabBar() {
        
        var storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        let home = UINavigationController(rootViewController: homeViewController)
        home.tabBarItem = homeTab
        
        guard let calendarViewController = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else {return}
        let calendar = UINavigationController(rootViewController: calendarViewController)
        calendar.tabBarItem = calendarTab
        
        guard let searchViewController = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else {return}
        let search = UINavigationController(rootViewController: searchViewController)
        searchViewController.tabBarItem = searchTab
        
        guard let heartViewController = UIStoryboard(name: "Heart", bundle: nil).instantiateViewController(withIdentifier: "HeartViewController") as? HeartViewController else {return}
        let heart = UINavigationController(rootViewController: heartViewController)
        heartViewController.tabBarItem = heartTab
        
        guard let storeViewController = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController else {return}
        let store = UINavigationController(rootViewController: storeViewController)
        storeViewController.tabBarItem = storeTab
        
        

        // TODO: 분기 처리 리팩토링 필요
        if APIManeger.shared.getHeader() != nil {
            storyboard = UIStoryboard.init(name: "LoginUserMypage", bundle: nil)
            guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "LoginMyPageViewController") as? LoginMyPageViewController else { return }
            let mypage = UINavigationController(rootViewController: mypageViewController)
            mypage.tabBarItem = mypageTab
            
            switch APIManeger.shared.getUserInfo()?.role {
            case "판매자" :
                getSellerProfile {
                    storeViewController.storeIdx = self.storeIdx
                    self.viewControllers = [
                        store,
                        mypage
                    ]
                }
            default:
                viewControllers = [
                    home,
                    calendar,
                    search,
                    heart,
                    mypage
                ]
            }

        } else {
            storyboard = UIStoryboard.init(name: "UnLoginUserMypage", bundle: nil)
            guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "UnLoginMyPageViewController") as? UnLoginMyPageViewController else { return }
            let mypage = UINavigationController(rootViewController: mypageViewController)
            mypage.tabBarItem = mypageTab

            viewControllers = [
                home,
                calendar,
                searchViewController,
                heart,
                mypage
            ]
        }
    }

}

extension DefaultTabBarController {
    func getSellerProfile(completionHanlder: @escaping () -> Void) {
        APIManeger.shared.testGetData(urlEndpointString: "/stores/profile", dataType: SellerProfileResponse.self, parameter: nil) { [weak self] response in
            self?.storeIdx = response.result.storeIdx
            completionHanlder()
        }
    }
    
    
}
