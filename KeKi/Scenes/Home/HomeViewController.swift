//
//  HomeViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

private let URL_ENDPOINT_STR = "/calendars/home"

class HomeViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    @objc let refreshControl = UIRefreshControl()

    // TODO: 기본 멘트로 ddayCountingText 재설정 필요 -> 논의 후 설정할 예정
    private var ddayCountingText: String? = "어서오세요! \n당신의 특별한 기념일을! \n케키와 함께 준비해요"
    
    private var nickname: String? = nil
    private var calendarTitle: String? = nil
    private var calendarDate: Int? = -1
    
    private var homeData: HomeResponse? = nil
    private var homeStoreDataList: [HomeTagRes] = []

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ddayCountingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        setUpDdayCountingLabel()
        setupTableView()
        initRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapChatButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "안내", message: "채팅 기능은 곧 업데이트될 예정입니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func didTapNotificationButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "안내", message: "알림 기능은 곧 업데이트될 예정입니다!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func initRefresh() {
        refreshControl.addTarget(self, action: #selector(refreshView(refresh: )), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    private func setUpDdayCountingLabel() {
        let attributedString = NSMutableAttributedString(string: ddayCountingText!)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 8
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        ddayCountingLabel.attributedText = attributedString
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
    }
    
    @objc private func refreshView(refresh: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            self.tableView.reloadData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - Extensions
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        if (homeData != nil) && (homeStoreDataList.count > indexPath.section) {
            cell.tagDetailDelegate = self
            cell.setData(sectionData: homeStoreDataList[indexPath.section])
            cell.reloadCell()
        }
        return cell
    }

}

extension HomeViewController: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }

}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {}
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {}
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true     // 스크린 맨 위를 누르면 가장 상단으로 이동
    }
}

// MARK: 네트워크 통신 관련 extension
extension HomeViewController {
    private func fetchData(){
        APIManeger.shared.testGetData(urlEndpointString: URL_ENDPOINT_STR,
                                      dataType: HomeResponse.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in
            self?.homeData = response.self
            self?.homeStoreDataList = response.result.homeTagResList
            self?.tableView.reloadData()
            
            print("response:: \(response)")
            
            if let nickname = response.result.nickname {
                if let calendarTitle = response.result.calendarTitle,
                   let calendarDate = response.result.calendarDate {
                    self?.ddayCountingLabel.text = "\(nickname)님! \n\(calendarTitle)이 \(calendarDate)일 남았어요! \n특별한 하루를 준비해요"
                } else {
                    self?.ddayCountingLabel.text = "어서오세요! \n\(nickname)님의 특별한 기념일을! \n케키와 함께 준비해요"
                }
            }
            
        })
    }
}

extension HomeViewController: TagDetailDelegate {
    func tapTagAction(tagTitle: String) {
        let storyboard = UIStoryboard.init(name: "Search", bundle: nil)
        guard let searchResultViewController = storyboard.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }

        let tag = tagTitle.trimmingCharacters(in: ["#"," "])
        searchResultViewController.search(searchText: nil,
                                          hashTag: tag,
                                          sortType: SortType.Recent.rawValue,
                                          cursorIdx: nil,
                                          cursorPopularNum: nil,
                                          cursorPrice: nil)
        searchResultViewController.setHashTag(text: tag)
        self.navigationController?.pushViewController(searchResultViewController, animated: true)
    }
}
