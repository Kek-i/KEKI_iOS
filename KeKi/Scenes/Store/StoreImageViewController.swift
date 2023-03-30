//
//  StoreImageViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/30.
//

import UIKit
import Alamofire

class StoreImageViewController: UIViewController {
    
    @IBOutlet weak var storeImageCV: UICollectionView!
    @IBOutlet weak var feedAddButton: UIButton!
    
    var storeIdx: Int = -1
    var feeds: Array<Feed> = []
    var queryParam: Parameters = [:]
    
    
    var cursorIdx: Int?
    var cursorPrice: Int?
    var cursorPopularNum: Int?
    var hasNext: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    func setup() {
        storeImageCV.delegate = self
        storeImageCV.dataSource = self
    }

    func setupLayout() {
        if APIManeger.shared.getHeader() == nil {
            feedAddButton.layer.isHidden = true
            return
        }else {
            if APIManeger.shared.getUserInfo()?.role == "판매자"{
                feedAddButton.layer.cornerRadius = 25
                
                feedAddButton.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
                feedAddButton.layer.shadowOffset = CGSize(width: 0, height: 3)
                feedAddButton.layer.shadowRadius = 6
                feedAddButton.layer.shadowOpacity = 1.0
                
            }else {
                feedAddButton.layer.isHidden = true
            }
        }
        
    }
    
    func configure(feeds: [Feed], storeIdx: Int, cursorIdx: Int, hasNext: Bool) {
        self.feeds = feeds
        self.storeIdx = storeIdx
        self.cursorIdx = cursorIdx
        self.hasNext = hasNext
        
        storeImageCV?.reloadData()
    }
    
    func setStoreIdx(storeIdx: Int) {
        self.storeIdx = storeIdx
    }
    
    @IBAction func feedAdd(_ sender: Any) {
        guard let feedAddView = UIStoryboard(name: "FeedAdd", bundle: nil).instantiateViewController(withIdentifier: "FeedAddViewController") as? FeedAddViewController else {return}
        
        
        feedAddView.modalTransitionStyle = .coverVertical
        feedAddView.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(feedAddView, animated: true)
    }
}


extension StoreImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreImageCell", for: indexPath) as? StoreImageCell else { return UICollectionViewCell() }
        
        if let imgUrl = feeds[indexPath.row].postImgUrls?[0] {
            if imgUrl.contains("https:") {
                // https:...형태의 Url
                cell.storeImageView.kf.setImage(with: URL(string: imgUrl))
            } else {
                // 디렉토리 형태의 Url
                let _ = FirebaseStorageManager.downloadImage(urlString: imgUrl, completion: { img in
                    cell.storeImageView.image = img
                })
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.tag == 4 {
            self.loadMoreFeed(index: indexPath.item)
        }
        
    }
}

extension StoreImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 20) / 3 - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Feed", bundle: nil)
        guard let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController else { return }
        
        feedViewController.feedData = self.feeds
        feedViewController.focusingIdx = indexPath
        if let vc = self.next(ofType: UIViewController.self) {
            vc.tabBarController?.tabBar.isHidden = true
            vc.navigationController?.pushViewController(feedViewController, animated: true)
        }
    }
}

extension StoreImageViewController {
    func loadMoreFeed (index: Int) {
        if index != 0 && index % 11 == 0 && self.hasNext == true{
            setQueryParam(storeIdx: self.storeIdx, cursorIdx: self.cursorIdx)
        }
    }
}


extension StoreImageViewController {
    func setQueryParam(storeIdx: Int?, cursorIdx: Int?) {
        queryParam["storeIdx"] = storeIdx
        queryParam["cursorIdx"] = cursorIdx
        
        getFeedList(queryParam: queryParam)
    }
    
    
    func getFeedList(queryParam: Parameters) {
        APIManeger.shared.testGetData(urlEndpointString: "/posts", dataType: SearchResultResponse.self, parameter: queryParam) { [weak self] response in
            
            self?.hasNext = response.result.hasNext
            self?.cursorIdx = response.result.cursorIdx
            
            response.result.feeds?.forEach({ feed in
                self?.feeds.append(feed)
            })
            
            self?.storeImageCV.reloadData()
        }
    }
}
