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
    
    var feedList: Array<HeartFeed> = []
    
    var hasNext: Bool?
    var cursorDate: String?
    var queryParam: Parameters = [:]
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupNavigationBar()
        getHeart(cursorDate: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getHeart(cursorDate: nil)
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
            
            if let imageUrl = URL(string: feedList[indexPath.row].postImgUrl) {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    heatCell.productImageView.image = imageResize(image: UIImage(data: imageData)!, newWidth: 105, newHeight: 105)
                }
            }
            
            
        }
        
        return cell
    }
    
    func imageResize(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Feed", bundle: nil)
        guard let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController else { return }
//        feedViewController.feedData = feedList
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
            getHeart(cursorDate: self.cursorDate)
            isLoading = true
        }
    }
    
    
    
}


extension HeartViewController {
    func getHeart(cursorDate: String?) {
        if isLoading == true {
            return
        }
        
        queryParam["cursorDate"] = cursorDate
        fetchHeartList(queryParam: queryParam)
    }
    
    func fetchHeartList(queryParam: Parameters) {
        APIManeger.shared.getData(urlEndpointString: "/posts/likes", dataType: HeartResponse.self, header: APIManeger.buyerTokenHeader, parameter: nil) { [weak self] response in
            print(response)
            
            self?.feedList = response.result.feeds
            
            self?.hasNext = response.result.hasNext
            self?.cursorDate = response.result.cursorDate
            
            self?.heartCV.reloadData()
        }
    }
}
