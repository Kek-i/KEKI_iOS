//
//  HeartViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/03/12.
//

import UIKit
import Alamofire

class HeartViewController: UIViewController {

    @IBOutlet weak var heartCV: UICollectionView!
    
    var feedList: Array<Feed> = []
    
    var hasNext: Bool?
    var cursorDate: String?
    var queryParam: Parameters = [:]
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
        getHeart()
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
        return feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeartCell", for: indexPath)
        if let heatCell = cell as? HeartDetailCell {
            heatCell.productTitleLabel.text = feedList[indexPath.row].dessertName
            heatCell.productPriceLabel.text = feedList[indexPath.row].dessertPrice.description
            
            if let imageUrl = URL(string: feedList[indexPath.row].postImgUrls[0]) {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    heatCell.productImageView.image = (UIImage(data: imageData)!)
                }
            }
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Feed", bundle: nil)
        guard let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController else { return }
        feedViewController.feedData = feedList
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if heartCV.contentOffset.y > heartCV.contentSize.height-heartCV.bounds.size.height && self.hasNext == true{
            getHeart()
            isLoading = true
        }
    }
    
    
}


extension HeartViewController {
    func getHeart() {
        if isLoading == true {
            return
        }
        
        queryParam["cursorDate"] = cursorDate
        fetchHeartList(queryParam: queryParam)
    }
    
    
    func fetchHeartList(queryParam: Parameters) {
        APIManeger.shared.getData(urlEndpointString: "/posts/likes", dataType: HeartResponse.self, header: APIManeger.buyerTokenHeader, parameter: queryParam) { [weak self] response in
            print(response)
            
            self?.feedList = response.result.feeds
            
            self?.hasNext = response.result.hasNext
            self?.cursorDate = response.result.cursorDate
            
            self?.heartCV.reloadData()
        }
    }
}
