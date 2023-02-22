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
    private let mypageTab = UITabBarItem(title: nil, image: UIImage(named: "mypage"), selectedImage: UIImage(named: "mypage.fill"))
    
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
        
        let heartViewController = UIViewController()
        heartViewController.tabBarItem = heartTab

        // TODO: 분기 처리 리팩토링 필요
        if APIManeger.shared.getHeader() != nil {
            storyboard = UIStoryboard.init(name: "LoginUserMypage", bundle: nil)
            guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "LoginMyPageViewController") as? LoginMyPageViewController else { return }
            let mypage = UINavigationController(rootViewController: mypageViewController)
            mypage.tabBarItem = mypageTab

            viewControllers = [
                home,
                calendar,
                search,
                heartViewController,
                mypage
            ]
            
        } else {
            storyboard = UIStoryboard.init(name: "UnLoginUserMypage", bundle: nil)
            guard let mypageViewController = storyboard.instantiateViewController(withIdentifier: "UnLoginMyPageViewController") as? UnLoginMyPageViewController else { return }
            let mypage = UINavigationController(rootViewController: mypageViewController)
            mypage.tabBarItem = mypageTab

            viewControllers = [
                home,
                calendar,
                searchViewController,
                heartViewController,
                mypage
            ]
        }
    }

}
