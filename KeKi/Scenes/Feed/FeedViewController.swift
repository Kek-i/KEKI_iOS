//
//  FeedViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class FeedViewController: UIViewController {
    // MARK: - Variables, IBOutlet, ...
    var postIdx: Int = -1   // 피드 개별 조회할 경우, postIdx 값이 변경 -> API 호출 다르게 하도록
    private var feedData: [Feed] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    func setData(postIdx: Int) {
        fetchData()
    }
    
    private func fetchData() {
        if postIdx != -1 {
            // 개별 피드 조회
            APIManeger.shared.testGetData(urlEndpointString: "/posts/\(postIdx)",
                                          dataType: SingleFeedResponse.self,
                                          parameter: nil,
                                          completionHandler: { [weak self] response in
                    
                if response.isSuccess { self?.feedData.append(response.result) }
                self?.tableView.reloadData()
                
            })
        }
        else {
            // TODO: 피드 목록 조회 (by 스토어명 / 검색어 / 태그명)
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "피드"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackItem))
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
    }
    
    @objc private func didTapBackItem() { self.navigationController?.popViewController(animated: true) }
    
}

// MARK: - Extensions
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("feedData.count :: \(feedData.count)")
        return feedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
                as? FeedCell else { return UITableViewCell() }
        cell.setup()
        cell.feedAlertDelegate = self
        cell.configure(data: feedData[indexPath.row])
        if feedData.count == 1 { cell.setSingleFeedView() }
        cell.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.backgroundColor = .white
    }
}

extension FeedViewController: AlertDelegate {
    
    func showFeedMainAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let declarationAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            self?.showFeedDeclarationActionAlert()
        }
        
        let notToSeeAction = UIAlertAction(title: "게시글 보지 않기", style: .default) {_ in
            // TODO: 게시글 안 보이게 하는 기능 구현
        }
        
        let blockAction = UIAlertAction(title: "차단하기", style: .default) {_ in
            // TODO: 피드 게시자 차단 기능 구현
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [
            declarationAction,
            notToSeeAction,
            blockAction,
            cancelAction
        ].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func showFeedDeclarationActionAlert() {
        let alert = UIAlertController(title: "신고 사유 선택", message: "타당한 신고사유를 선택해주세요. \n신고사유에 맞지않는 신고일 경우, 해당신고는 처리되지 않습니다.", preferredStyle: .actionSheet)
        
        let declarationAction = UIAlertAction(title: "스팸홍보/도배", style: .default)
        let abuseAction = UIAlertAction(title: "욕설/혐오/차별", style: .default)
        let noxiousAction = UIAlertAction(title: "음란물/유해한 정보", style: .default)
        let illegalAction = UIAlertAction(title: "사기/불법정보", style: .default)
        let inappropriatenessAction = UIAlertAction(title: "게시글 성격에 부적절함", style: .default)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        [
            declarationAction,
            abuseAction,
            noxiousAction,
            illegalAction,
            inappropriatenessAction,
            cancelAction
        ].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
}
