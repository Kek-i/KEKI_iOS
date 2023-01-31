//
//  SearchViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/01/31.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    @IBOutlet weak var recentSearchCV: UICollectionView!{
        didSet{
            collectionViewInit(cv: recentSearchCV)
            
            recentSearchCV.tag = 1
            
            let recentSearchCellNib = UINib(nibName: "RecentSearchCell", bundle: nil)
            recentSearchCV.register(recentSearchCellNib, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var popularSearchCV: UICollectionView!{
        didSet{
            collectionViewInit(cv: popularSearchCV)
            
            popularSearchCV.tag = 2
            
            let popularSearchCellNib = UINib(nibName: "PopularSearchCell", bundle: nil)
            popularSearchCV.register(popularSearchCellNib, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var recentCakeCV: UICollectionView!{
        didSet{
            collectionViewInit(cv: recentCakeCV)
            
            recentCakeCV.tag = 3
            
            let recentCakeCellNib = UINib(nibName: "RecentCakeCell", bundle: nil)
            recentCakeCV.register(recentCakeCellNib, forCellWithReuseIdentifier: "cell")
        }
    }
    
    // 임시
    var recentTextList: Array<String> = ["생일케이크", "합격 축하" , "크리스마스" , "딸기 케이크 맛집", "초코 케이크 맛집"]
    var popularTextList: Array<String> = ["친구", "가족" , "기념일" , "1주년", "생일파티"]
    
    var popularColorList: Array<CGColor> = [CGColor(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 223.0 / 255.0, alpha: 1),
                                            CGColor(red: 250.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1),
                                            CGColor(red: 244.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                                            CGColor(red: 244.0 / 255.0, green: 219.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                                            CGColor(red: 243.0 / 255.0, green: 224.0 / 255.0, blue: 250.0 / 255.0, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIInit()
    }
    
    func UIInit() {
        searchView.layer.cornerRadius = 23
        searchTextField.layer.cornerRadius = 23
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor(red: 224.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1)])
    }
    
    func collectionViewInit(cv: UICollectionView){
        cv.delegate = self
        cv.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        cv.collectionViewLayout = flowLayout
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if collectionView.tag == 1 {
            if let recentSearchCell = cell as? RecentSearchCell {
                recentSearchCell.recentLabel.text = recentTextList[indexPath.row]
            }
            
        }else if collectionView.tag == 2 {
            if let popluarSearchCell = cell as? PopularSearchCell {
                popluarSearchCell.popularLabel.text = "# " + popularTextList[indexPath.row]
                popluarSearchCell.setBackgroundColor(color: popularColorList[indexPath.row % 5])
            }
        }
        
        return cell
    }
    
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let tmpLabel = UILabel()
            tmpLabel.text = recentTextList[indexPath.row]
            return CGSize(width: tmpLabel.intrinsicContentSize.width+13, height: 26)
        }else if collectionView.tag == 2 {
            let tmpLabel = UILabel()
            tmpLabel.text = "# " + popularTextList[indexPath.row]
            return CGSize(width: tmpLabel.intrinsicContentSize.width+14, height: 26)
        }else{
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    }
}
