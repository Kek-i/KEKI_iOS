//
//  SearchViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/01.
//

import UIKit
import Alamofire

enum SortType: String {
    case Recent = "최신순"
    case Popular = "인기순"
    case LowPrice = "낮은 가격순"
}
extension SortType {
    func getHideTitle() -> [String] {
        switch self {
        case .Recent:
            return [SortType.Popular.rawValue, SortType.LowPrice.rawValue]
        case .Popular:
            return [SortType.Recent.rawValue, SortType.LowPrice.rawValue]
        case .LowPrice:
            return [SortType.Recent.rawValue, SortType.Popular.rawValue]
        }
    }
        
    func getRequestType() -> String {
        switch self {
        case .Recent:
            return "최신순"
        case .Popular:
            return "인기순"
        case .LowPrice:
            return "가격낮은순"
        }
    }
    
}

class SearchViewController: UIViewController { 
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var recentDeleteButton: UIButton!
    @IBOutlet weak var recentCV: UICollectionView!
    @IBOutlet weak var popularCV: UICollectionView!
    @IBOutlet weak var recentCakeCV: UICollectionView!
    
    @IBOutlet weak var resultView: UIView!
    
    
    @IBOutlet weak var sortTypeButtonView: UIView!
    
    @IBOutlet weak var sortTypeButton: UIButton!
    @IBOutlet weak var hideSortTypeButton1: UIButton!
    @IBOutlet weak var hideSortTypeButton2: UIButton!
    
    @IBOutlet weak var sortTypeButtonViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noResultImageView: UIImageView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    @IBOutlet weak var searchResultCV: UICollectionView!
 
    
    private var searchText:String?
    private var hashTag:String?
    
    private var sortType:SortType = .Recent
    
    private var sortOpen = false
    private var isLoading = false
    
    var recentTextList: Array<Search> = []
    var popularTextList: Array<Search> = []
    var recentCakeList: Array<RecentPostSearch> = []
    var searchResultList: Array<Feed> = []
    var queryParam: Parameters = [:]
    
    var cursorIdx: Int?
    var cursorPrice: Int?
    var cursorPopularNum: Int?
    var hasNext: Bool?
    
    var popularColorList: Array<CGColor> = [CGColor(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 223.0 / 255.0, alpha: 1),
                                            CGColor(red: 250.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1),
                                            CGColor(red: 244.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                                            CGColor(red: 244.0 / 255.0, green: 219.0 / 255.0, blue: 203.0 / 255.0, alpha: 1),
                                            CGColor(red: 243.0 / 255.0, green: 224.0 / 255.0, blue: 250.0 / 255.0, alpha: 1)]
    
    
    var checkSearch = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        fetchSearchMain()
    }
    
    func setup() {
        searchTextField.delegate = self
        
        var tag = 1
        
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
        
        [recentCV, popularCV, recentCakeCV].forEach { cv in
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            
            cv?.collectionViewLayout = flowLayout
            cv?.showsHorizontalScrollIndicator = false
        }
        
        searchView.layer.cornerRadius = 23
        searchTextField.layer.cornerRadius = 23
        
        
        let buttonTitleAttributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 11),
              .foregroundColor: UIColor.gray,
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        
        let attributeString = NSMutableAttributedString(string: "전체 지우기", attributes: buttonTitleAttributes)
        
        recentDeleteButton.setAttributedTitle(attributeString, for: .normal)
       
        
        searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [.foregroundColor: UIColor(red: 224.0 / 255.0, green: 187.0 / 255.0, blue: 187.0 / 255.0, alpha: 1)])
        
        sortTypeButtonView.layer.cornerRadius = 16
        sortTypeButtonView.layer.borderWidth = 1.5
        sortTypeButtonView.layer.borderColor = CGColor(red: 227 / 255, green: 227 / 255, blue: 227 / 255, alpha: 1)
        
        setHideButtonTitle()
        [hideSortTypeButton1, hideSortTypeButton2].forEach { btn in
            btn?.isHidden = true
        }
        
        self.sortTypeButtonViewHeight.priority = UILayoutPriority(1000)
        sortTypeButtonView.layer.masksToBounds = false
    }
    
    func setHideButtonTitle() {
        sortTypeButton.setTitle(sortType.rawValue, for: .normal)
        var index = 0
        [hideSortTypeButton1, hideSortTypeButton2].forEach { btn in
            let hideTitleList = sortType.getHideTitle()
            btn?.setTitle(hideTitleList[index], for: .normal)
            index += 1
        }
    }
    
    func showMainView() {
        sortType = .Recent
        setHideButtonTitle()
        
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
        searchResultCV.reloadData()
        searchResultCV.isHidden = false
        
    }
    
    
    @IBAction func deleteRecent(_ sender: Any) {
        deleteRecentSearches()
    }
    
    
    
    @IBAction func openSortButtonView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            if self.sortOpen == false {
                self.sortTypeButtonView.layer.masksToBounds = false
                self.sortTypeButtonViewHeight.priority = UILayoutPriority(250)
                [self.hideSortTypeButton1, self.hideSortTypeButton2].forEach {
                $0?.isHidden = false
            }
        }else {
            self.sortTypeButtonView.layer.masksToBounds = true
            self.sortTypeButtonViewHeight.priority = UILayoutPriority(1000)
            [self.hideSortTypeButton1, self.hideSortTypeButton2].forEach {
                $0?.isHidden = true
            }
        }
        }
        self.view.layoutIfNeeded()
        
        sortOpen.toggle()
    }
    
    
    @IBAction func selectSortType(_ sender: UIButton) {
        if sender.currentTitle == SortType.Recent.rawValue{
            cursorPopularNum = nil
            cursorPrice = nil
            sortType = .Recent
        }else if sender.currentTitle == SortType.Popular.rawValue{
            cursorPrice = nil
            sortType = .Popular
        }else if sender.currentTitle == SortType.LowPrice.rawValue{
            cursorPopularNum = nil
            sortType = .LowPrice
        }
        openSortButtonView(self)
        
        searchResultList.removeAll()
        
        search(searchText: searchText, hashTag: hashTag, sortType: sortType.getRequestType(), cursorIdx: nil, cursorPopularNum: nil, cursorPrice: nil)

        setHideButtonTitle()
    }
    
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        hashTag = nil
        searchText = textField.text
        
        search(searchText: searchText, hashTag: nil, sortType: sortType.getRequestType(), cursorIdx: nil, cursorPopularNum: nil, cursorPrice: nil)
        
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text == nil || textField.text == ""{
            searchText = nil
            fetchSearchMain()
            showMainView()
        }
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return recentTextList.count
        }else if collectionView.tag == 2{
            return popularTextList.count
        }else if collectionView.tag == 3 {
            return recentCakeList.count
        }else  {
            return searchResultList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        if collectionView.tag == 1 {
            if let recentSearchCell = cell as? RecentSearchCell {
                recentSearchCell.recentLabel.text = recentTextList[indexPath.row].searchWord
            }
            
        }else if collectionView.tag == 2 {
            if let popluarSearchCell = cell as? PopularSearchCell {
                popluarSearchCell.popularLabel.text = "# " + popularTextList[indexPath.row].searchWord
                popluarSearchCell.setBackgroundColor(color: popularColorList[indexPath.row % 5])
            }
        }else if collectionView.tag == 3 {
            if let recentCakeCell = cell as? RecentCakeCell {
                guard let imageUrl = URL(string: recentCakeList[indexPath.row].postImgURL) else {return cell}
                guard let imageData = try? Data(contentsOf: imageUrl) else {return cell}
                guard let image = UIImage(data: imageData) else {return cell}
                 
                recentCakeCell.recentCakeImageView.image = imageRsize(image: image, newWidth: 100, newHeight: 100)
            }
        }else {
            if let searchDetailCell = cell as? SearchDetailCell {
                guard let imageUrl = URL(string: searchResultList[indexPath.row].postImgUrls[0] ) else {return cell}
                guard let imageData = try? Data(contentsOf: imageUrl) else {return cell}
                
                guard let image = UIImage(data: imageData) else {return cell}
                 
                searchDetailCell.productImageView.image = imageRsize(image: image, newWidth: 105, newHeight: 105)
                searchDetailCell.productTitleLabel.text = searchResultList[indexPath.row].dessertName
                searchDetailCell.productPriceLabel.text = searchResultList[indexPath.row].dessertPrice.description
            }
        }
        
        return cell
    }
    
    func imageRsize(image: UIImage, newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        let size = CGSize(width: newWidth, height: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        return renderImage
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 {
            searchText = recentTextList[indexPath.row].searchWord
            hashTag = nil
            search(searchText: searchText, hashTag: nil, sortType: sortType.getRequestType(), cursorIdx: nil, cursorPopularNum: nil, cursorPrice: nil)
        }else if collectionView.tag == 2 {
            hashTag = popularTextList[indexPath.row].searchWord
            searchText = nil
            search(searchText: nil, hashTag: hashTag, sortType: sortType.getRequestType(), cursorIdx: nil, cursorPopularNum: nil, cursorPrice: nil)
        }else if collectionView.tag == 3 {
           
        }else {
           
        }
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
            tmpLabel.text = recentTextList[indexPath.row].searchWord
            return CGSize(width: tmpLabel.intrinsicContentSize.width+20, height: 26)
        }else if collectionView.tag == 2 {
            let tmpLabel = UILabel()
            tmpLabel.text = "# " + popularTextList[indexPath.row].searchWord
            return CGSize(width: tmpLabel.intrinsicContentSize.width+20, height: 26)
        }else if collectionView.tag == 3{
            return CGSize(width: 100, height: 100)
        }else {
            return CGSize(width: 105, height: 152)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView.tag == 4{
            let tabBarHeight = self.tabBarController?.tabBar.frame.height
            return UIEdgeInsets(top: 0, left: 20, bottom: tabBarHeight!/2, right: 19)
        }else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
        }
    }
}


extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.searchResultCV.contentOffset.y > searchResultCV.contentSize.height-searchResultCV.bounds.size.height && self.hasNext == true{
            search(searchText: searchText, hashTag: hashTag, sortType: sortType.getRequestType(), cursorIdx: cursorIdx, cursorPopularNum: cursorPopularNum, cursorPrice: cursorPrice)
            isLoading = true
        }
    }
}

// 서버 통신 api
extension SearchViewController {
    func fetchSearchMain() {
        // MARK: 로그인 토큰 있을 시 검색 메인 화면
        APIManeger.shared.getData(urlEndpointString: "/histories", dataType: SearchMainResponse.self, header: APIManeger.buyerTokenHeader, parameter: nil) { [weak self] response in
            
            self?.recentTextList = response.result.recentSearches
            self?.popularTextList = response.result.popularSearches
            self?.recentCakeList = response.result.recentPostSearches
            
            self?.recentCV.reloadData()
            self?.popularCV.reloadData()
            self?.recentCakeCV.reloadData()
        }
        
        // MARK: 로그인 토큰 없을 시 검색 메인 화면
//        APIManeger.shared.getData(urlEndpointString: "/histories", dataType: NoLoginSearchMainResponse.self, header: nil) { [weak self] response in
//            print(response)
//            self?.popularTextList = response.result.popularSearches
//            self?.popularCV.reloadData()
//        }
    }
    
    // MARK: 최근 검색어 - GET
    func fetchRecnetSearches() {
        APIManeger.shared.getData(urlEndpointString: "/histories/recent-searches", dataType: RecentSearchesResponse.self, header: APIManeger.buyerTokenHeader, parameter: nil) { [weak self] response in
            self?.recentTextList = response.result
            self?.recentCV.reloadData()
        }
    }
    
    // MARK: 최근 검색어 삭제 - PATCH
    func deleteRecentSearches() {
        APIManeger.shared.patchData(urlEndpointString: "/histories", dataType: SearchMainResponse.self, header: APIManeger.buyerTokenHeader, parameter: nil) { [weak self] response in
            if response.isSuccess == true {
                self?.fetchRecnetSearches()
            }
        }
    }
    
    // MARK: 검색 파라미터 만든 후 검색
    func search(searchText: String?, hashTag: String?, sortType: String, cursorIdx: Int?, cursorPopularNum: Int?, cursorPrice: Int?) {
        if isLoading == true {
            return
        }
        
        queryParam["searchWord"] = searchText
        queryParam["searchTag"] = hashTag
        queryParam["sortType"] = sortType
        queryParam["cursorIdx"] = cursorIdx
        queryParam["cursorPopularNum"] = cursorPopularNum
        queryParam["cursorPrice"] = cursorPrice
        
        fetchSearchResult(queryParam: queryParam)
    }
    
    // MARK: 검색 - GET
    func fetchSearchResult(queryParam: Parameters) {
        APIManeger.shared.getData(urlEndpointString: "/posts", dataType: SearchResultResponse.self, header: APIManeger.buyerTokenHeader, parameter: queryParam) { [weak self] response in
            if response.result.feeds?.count != 0 {
                response.result.feeds?.forEach({ feed in
                    self?.searchResultList.append(feed)
                })
                
                self?.cursorIdx = response.result.cursorIdx
                self?.hasNext = response.result.hasNext
                
                if self?.sortType == .Popular {
                    self?.cursorPopularNum = response.result.cursorPopularNum
                }else if self?.sortType == .LowPrice {
                    self?.cursorPrice = response.result.cursorPrice
                }
                self?.showResultView()
            }else {
                self?.showNoResultView()
            }
            
            self?.isLoading = false
        }
        
        
    }
}
