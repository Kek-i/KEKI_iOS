//
//  SearchMainViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit

class SearchMainViewController: UIViewController {
     

    
    // 임시
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func setup() {
        [recentSearchCV,popularSearchCV, recentCakeCV].forEach { cv in
            cv.delegate = self
            cv.dataSource = self
            
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            
            cv.collectionViewLayout = flowLayout
        }
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        if checkSearch == true {
            guard let searchDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailViewController") as? SearchDetailViewController else {return}
            
            guard let searchNothingVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchNothingViewController") as? SearchNothingViewController else {return}
            
            searchDetailVC.modalPresentationStyle = .fullScreen
            searchNothingVC.modalPresentationStyle = .fullScreen
            
            if searchText == nil {
                self.present(searchNothingVC, animated: false)
            }else {
                self.present(searchDetailVC, animated: false)
            }
        }
    }
    
    func search(text: String?) {
        searchText = text
        checkSearch = true
        
        viewDidAppear(true)
    }
    
}

extension SearchMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

extension SearchMainViewController: UICollectionViewDelegateFlowLayout {
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
