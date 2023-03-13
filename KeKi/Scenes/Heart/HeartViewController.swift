//
//  HeartViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/03/12.
//

import UIKit

class HeartViewController: UIViewController {

    @IBOutlet weak var heartCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
    }
    
    
    func setup() {
        heartCV.dataSource = self
        heartCV.delegate = self
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        
        let title = UILabel()
        title.text = "좋아요"
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textAlignment = .left
        title.sizeToFit()

        let titleItem = UIBarButtonItem(customView: title)
    
        self.navigationItem.leftBarButtonItem = titleItem
        
        // action에 addDay 추가 (서버 연결 후)
        let menuButton = UIBarButtonItem(image: UIImage(named: "option"), style: .done, target: self, action: #selector(openMenu))
        menuButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = menuButton
    }
    
    @objc func openMenu() {
        
    }

}

extension HeartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeartCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Feed", bundle: nil)
        guard let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController else { return }
//        feedViewController.feedData = heartList
        self.navigationController?.pushViewController(feedViewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height
        return UIEdgeInsets(top: 0, left: 20, bottom: tabBarHeight!/2, right: 19)
    }
    
    
}


extension HeartViewController {
    
}
