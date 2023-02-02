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
        tabFrame.size.height = 100
        tabFrame.origin.y = self.view.frame.size.height - 100
        tabBar.frame = tabFrame
        
        setLayoutTabBar()
    }
    
    private func setLayoutTabBar() {
        tabBar.unselectedItemTintColor = UIColor(red: 224/255, green: 187/255, blue: 187/255, alpha: 1)
        tabBar.tintColor = UIColor(red: 217/255, green: 72/255, blue: 106/255, alpha: 1)
        tabBar.barTintColor = .white
    }
    
    private func configureTabBar() {
        
        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
        guard let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        homeViewController.tabBarItem = homeTab
        
        let calendarViewController = UIViewController()
        calendarViewController.tabBarItem = calendarTab
        
        let searchViewController = UIViewController()
        searchViewController.tabBarItem = searchTab
        
        let heartViewController = UIViewController()
        heartViewController.tabBarItem = heartTab

        let mypageViewController = UIViewController()
        mypageViewController.tabBarItem = mypageTab

        
        viewControllers = [
            homeViewController,
            calendarViewController,
            searchViewController,
            heartViewController,
            mypageViewController
        ]
    }

}