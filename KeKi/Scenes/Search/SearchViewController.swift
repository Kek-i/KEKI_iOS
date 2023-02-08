//
//  SearchViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit

class SearchViewController: UIViewController { 
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var recentCV: UICollectionView!
    @IBOutlet weak var popularCV: UICollectionView!
    @IBOutlet weak var recentCakeCV: UICollectionView!
    
    @IBOutlet weak var resultView: UIView!
    
    @IBOutlet weak var searchTypeButton: UIButton!
    
    @IBOutlet weak var noResultImageView: UIImageView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    @IBOutlet weak var searchResultCV: UICollectionView!
 
    
    // 임시 데이터
    var recentTextList: Array<String> = ["생일케이크", "합격 축하" , "크리스마스" , "딸기 케이크 맛집", "초코 케이크 맛집"]
    var popularTextList: Array<String> = ["친구", "가족" , "기념일" , "1주년", "생일파티"]
    
    var popularColorList: Array<CGColor> = [CGColor(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 223.0 / 255.0, alpha: 1),
                                            CGColor(red: 250.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1),
                                            CGColor(red: 244.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                                            CGColor(red: 244.0 / 255.0, green: 219.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                                            CGColor(red: 243.0 / 255.0, green: 224.0 / 255.0, blue: 250.0 / 255.0, alpha: 1)]
    
    
    var searchText: String?
    var checkSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
    }
    
    func setup() {
        searchTextField.delegate = self
        
        var tag = 1
        
        [recentCV, popularCV, recentCakeCV].forEach { cv in
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            
            cv.collectionViewLayout = flowLayout
        }
        
        [recentCV, popularCV, recentCakeCV, searchResultCV].forEach { cv in
            cv?.delegate = self
            cv?.dataSource = self
            
            cv?.tag = tag
            tag += 1
        }
        mainView.isHidden = false
        resultView.isHidden = true
    }
    
    func setupLayout() {
        searchView.layer.cornerRadius = 23
        searchTextField.layer.cornerRadius = 23
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor(red: 224.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1)])
    }
    
    func showMainView() {
        mainView.isHidden = false
        resultView.isHidden = true
    }
    
    func showNoResultView() {
        mainView.isHidden = true
        resultView.isHidden = false
        
        noResultImageView.isHidden = false
        noResultLabel.isHidden = false
        searchResultCV.isHidden = true
    }
    
    func showResultView() {
        mainView.isHidden = true
        resultView.isHidden = false
        
        noResultImageView.isHidden = true
        noResultLabel.isHidden = true
        searchResultCV.isHidden = false
    }
    
    
    @IBAction func deleteRecent(_ sender: Any) {
        recentTextList.removeAll()
        recentCV.reloadData()
    }
    
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        search(text: textField.text)
        
        return true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == nil || textField.text == ""{
            showMainView()
        }
    }
    // 검색
    func search(text: String?){
        
        // 임시로 text가 비어있으면 검색결과 없음으로 표시
        if text == nil || text == "" {
           showNoResultView()
        }else {
            showResultView()
        }
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return recentTextList.count
        }else if collectionView.tag == 2{
            return popularTextList.count
        }else if collectionView.tag == 4 {
            return 10
        }else {
            return 5
        }
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
        if collectionView.tag == 4{
            return 11
        }else {
            return 10
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 1 {
            let tmpLabel = UILabel()
            tmpLabel.text = recentTextList[indexPath.row]
            return CGSize(width: tmpLabel.intrinsicContentSize.width+13, height: 26)
        }else if collectionView.tag == 2 {
            let tmpLabel = UILabel()
            tmpLabel.text = "# " + popularTextList[indexPath.row]
            return CGSize(width: tmpLabel.intrinsicContentSize.width+20, height: 26)
        }else if collectionView.tag == 3{
            return CGSize(width: 100, height: 100)
        }else {
            return CGSize(width: 105, height: 152)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 4{
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 19)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        }
    }
}


