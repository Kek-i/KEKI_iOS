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

    // TODO: 기본 멘트로 ddayCountingText 재설정 필요 -> 논의 후 설정할 예정
    private var ddayCountingText: String? = "베이님! \n투리 생일이 3일 남았어요! \n특별한 하루를 준비해요"
    
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
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        setUpDdayCountingLabel()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Action Methods (IBAction, ...)
    
    
    // MARK: - Helper Methods (Setup Method, ...)
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
}

// MARK: - Extensions
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else { return UITableViewCell() }
        if (homeData != nil) && (homeStoreDataList.count > indexPath.section) {
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
        APIManeger.shared.getData(urlEndpointString: URL_ENDPOINT_STR,
                                  dataType: HomeResponse.self,
                                  header: APIManeger.buyerTokenHeader,
                                  completionHandler: { [weak self] response in
            self?.homeData = response.self
            self?.homeStoreDataList = response.result.homeTagResList
            self?.tableView.reloadData()
            
            if let nickname = response.result.nickname,
               let calendarTitle = response.result.calendarTitle,
               let calendarDate = response.result.calendarDate {
                self?.ddayCountingLabel.text = "\(nickname)님! \n\(calendarTitle)이 \(calendarDate)일 남았어요! \n특별한 하루를 준비해요"
            }
            
        })
    }
}
