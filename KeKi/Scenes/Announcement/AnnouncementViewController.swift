//
//  AnnouncementViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

private let URL_ENDPOINT_STR = "/cs/notice"

class AnnouncementViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var announcementList: [AnnouncementListResponse.Result] = []
//    private var announcementList: [String] = [  // 임시 데이터 (서버연결 후 삭제 예정)
//        "새로운 디저트가 등록되었어요!",
//        "크리스마스 기념 할인행사",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요! 어서 확인해보세요",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//        "새로운 디저트가 등록되었어요!",
//    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupTableView()
        fetchData()
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AnnouncementCell", bundle: nil), forCellReuseIdentifier: "AnnouncementCell")
    }
}

// MARK: - Extensions
extension AnnouncementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementCell", for: indexPath)
                as? AnnouncementCell else { return UITableViewCell() }
        cell.titleLabel.text = announcementList[indexPath.row].noticeTitle
        cell.setupLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70   // default height
    }
}

extension AnnouncementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailView = storyboard?.instantiateViewController(withIdentifier: "AnnouncementDetailViewController") as? AnnouncementDetailViewController else { return }
        let backItem = UIBarButtonItem()
        backItem.title = "공지사항"
        navigationItem.backBarButtonItem = backItem
        let index = announcementList[indexPath.row].noticeIdx
        detailView.setIndex(index: index)
        navigationController?.pushViewController(detailView, animated: true)
    }
}

extension AnnouncementViewController {
    private func fetchData() {
        APIManeger.apiManager.getData(urlEndpointString: URL_ENDPOINT_STR, dataType: AnnouncementListResponse.self, header: nil, completionHandler: { [weak self] response in
            self?.announcementList = response.result
            self?.tableView.reloadData()
        })
    }
}
