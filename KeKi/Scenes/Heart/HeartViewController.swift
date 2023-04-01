//
//  HeartViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/03/12.
//

import UIKit
import Alamofire
import Kingfisher
import JGProgressHUD

class HeartViewController: UIViewController {

    @IBOutlet weak var heartCV: UICollectionView!
    
    var feedList: Array<HeartFeed> = []
    
    var hasNext: Bool? = false
    var cursorDate: String?
    var queryParam: Parameters = [:]
    var isInfiniteScroll = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = UserDefaults.standard.object(forKey: "userInfo") {
            setup()
            setupNavigationBar()
            getHeart(cursorDate: nil){}
        }
        else { showAlert() }
    }
        
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "회원가입 후 사용 가능한 서비스입니다", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "홈으로 이동", style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: false)
            let main = DefaultTabBarController()
            main.modalPresentationStyle = .fullScreen
            main.modalTransitionStyle = .crossDissolve
            self?.present(main, animated: true)
        }
        let join = UIAlertAction(title: "가입하기", style: .default) { [weak self] _ in
            let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
            guard let signupViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
            signupViewController.modalPresentationStyle = .fullScreen
            self?.present(signupViewController, animated: true)
        }
        alert.addAction(cancel)
        alert.addAction(join)
        present(alert, animated: true)
    }
    
    func setup() {
        heartCV.dataSource = self
        heartCV.delegate = self
//        heartCV.collectionViewLayout = CollectionViewLeftAlignFlowLayout()
//
//        if let flowLayout = heartCV?.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//      }
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
    }


}

extension HeartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeartCell", for: indexPath) as! HeartDetailCell

        cell.productTitleLabel.text = feedList[indexPath.row].dessertName
        cell.productPriceLabel.text = feedList[indexPath.row].dessertPrice.description
        
        
        let imgUrl = feedList[indexPath.row].postImgUrl
        
        if imgUrl.contains("https:") {
            // https:...형태의 Url
            cell.productImageView.kf.setImage(with: URL(string: imgUrl))
        } else {
            // 디렉토리 형태의 Url
            let _ = FirebaseStorageManager.downloadImage(urlString: imgUrl, completion: { img in
                cell.productImageView.image = img
            })
        }
        
        cell.setHeartFeed(heartFeed: feedList[indexPath.row])
        cell.setFirst(first: false)
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
        feedViewController.postIdx = feedList[indexPath.row].postIdx
        
        self.navigationController?.pushViewController(feedViewController, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 152)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 25, right: 19)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            if isInfiniteScroll && self.hasNext ?? false {
                isInfiniteScroll = false
                getHeart(cursorDate: self.cursorDate) {
                    self.isInfiniteScroll = true
                }
            }
        }
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    
}


extension HeartViewController {
    func getHeart(cursorDate: String?, completion: @escaping () -> Void) {
        queryParam["cursorDate"] = cursorDate
        fetchHeartList(queryParam: queryParam, completion: completion)
    }
    
    func fetchHeartList(queryParam: Parameters, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            hud.style = .light
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            
            APIManeger.shared.testGetData(urlEndpointString: "/posts/likes", dataType: HeartResponse.self, parameter: queryParam) { [weak self] response in
                hud.dismiss(animated: true)
                response.result.feeds.forEach { feed in
                    self?.feedList.append(feed)
                }
                
                self?.hasNext = response.result.hasNext
                self?.cursorDate = response.result.cursorDate
                
                self?.heartCV.reloadData()
                completion()
            }
            
            hud.dismiss(animated: true)
        }
        
    }
}



//class CollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
//    let cellSpacing: CGFloat = 25
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        self.minimumLineSpacing = 10.0
//        self.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0, right: 0.0)
//        let attributes = super.layoutAttributesForElements(in: rect)
//
//        var leftMargin = sectionInset.left
//        var maxY: CGFloat = -1.0
//        attributes?.forEach { layoutAttribute in
//            if layoutAttribute.frame.origin.y >= maxY {
//                leftMargin = sectionInset.left
//            }
//            layoutAttribute.frame.origin.x = leftMargin
//            leftMargin += layoutAttribute.frame.width + cellSpacing
//            maxY = max(layoutAttribute.frame.maxY, maxY)
//        }
//        return attributes
//    }
//}
