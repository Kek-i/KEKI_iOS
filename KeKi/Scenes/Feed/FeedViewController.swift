//
//  FeedViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit
import Toast

class FeedViewController: UIViewController {
    // MARK: - Variables, IBOutlet, ...
    var postIdx: Int = -1
    var focusingIdx: IndexPath?
    var dessertIdx: Int?
    var feedData: [Feed] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if feedData.count == 0 { fetchData() }
        
        setupNavigationBar()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    private func fetchData() {
        // 개별 피드 조회
        if postIdx != -1 {
            APIManeger.shared.testGetData(urlEndpointString: "/posts/\(postIdx)",
                                          dataType: SingleFeedResponse.self,
                                          parameter: nil,
                                          completionHandler: { [weak self] response in
                    
                if response.isSuccess { self?.feedData.append(response.result) }
                self?.tableView.reloadData()
                
            })
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "피드"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(didTapBackItem))
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")
        
        if let idx = focusingIdx {
            tableView.scrollToRow(at: idx, at: .middle, animated: true)
        }

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
        cell.feedDelegate = self
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

extension FeedViewController: FeedDelegate {
    func showToastMessage(message: String) {
        self.view.makeToast(message, duration: 1.0, position: .center)
    }
    
    func showProductDetail(dessertIdx: Int) {
        guard let productViewController = UIStoryboard(name: "ProductDetail", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as? ProductViewController else {return}
        
        productViewController.dessertIdx = dessertIdx
        navigationController?.pushViewController(productViewController, animated: true)
    }
    
    func showStoreMain(storeIdx: Int) {
        guard let storeViewController = UIStoryboard(name: "Store", bundle: nil).instantiateViewController(withIdentifier: "StoreViewController") as? StoreViewController else {return}
        
        storeViewController.storeIdx = storeIdx
        navigationController?.pushViewController(storeViewController, animated: true)
    }
    
    func showFeedMainAlert(postIdx: Int) {
        self.postIdx = postIdx
        
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
<<<<<<< HEAD
=======
        let declarationAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            if let _ = UserDefaults.standard.object(forKey: "userInfo") {
                self?.showFeedDeclarationActionAlert()
            } else {
                self?.view.makeToast("회원가입 후 피드 신고가 가능합니다", duration: 1.0, position: .center)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
>>>>>>> develop
        
        if APIManeger.shared.getHeader() != nil && APIManeger.shared.getUserInfo()?.role == "판매자" {
            
            let changeAction = UIAlertAction(title: "피드 수정", style: .default) { _ in
                self.editFeed()
            }
            let deleteAction = UIAlertAction(title: "피드 삭제", style: .default) { _ in
                self.checkDeleteFeed()
            }
            [
                changeAction,
                deleteAction,
            ].forEach { alert.addAction($0) }
        }else {
            let declarationAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
                self?.showFeedDeclarationActionAlert()
            }
            alert.addAction(declarationAction)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func showFeedDeclarationActionAlert() {
        let alert = UIAlertController(title: "신고 사유 선택", message: "타당한 신고사유를 선택해주세요. \n신고사유에 맞지않는 신고일 경우, 해당신고는 처리되지 않습니다.", preferredStyle: .actionSheet)
        
        let declarationAction = UIAlertAction(title: "스팸홍보/도배", style: .default) { [weak self] _ in self?.reportFeed(reason: "스팸홍보/도배") }
        let abuseAction = UIAlertAction(title: "욕설/혐오/차별", style: .default) { [weak self] _ in self?.reportFeed(reason: "욕설/혐오/차별") }
        let noxiousAction = UIAlertAction(title: "음란물/유해한 정보", style: .default) { [weak self] _ in self?.reportFeed(reason: "음란물/유해한 정보") }
        let illegalAction = UIAlertAction(title: "사기/불법정보", style: .default) { [weak self] _ in self?.reportFeed(reason: "사기/불법정보") }
        let inappropriatenessAction = UIAlertAction(title: "게시글 성격에 부적절함", style: .default) { [weak self] _ in self?.reportFeed(reason: "게시글 성격에 부적절함") }
        
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
    
    func reportFeed(reason: String) {
        let param = ReportFeed(reportName: reason)
        APIManeger.shared.testPostData(urlEndpointString: "/posts/\(postIdx)/report",
                                       dataType: ReportFeed.self,
                                       parameter: param,
                                       completionHandler: { [weak self] response in
            if response.code == 1000 {
                self?.view.makeToast("게시물 신고가 처리되었습니다", duration: 1.0, position: .center)
            } else {
                self?.view.makeToast("게시물 신고에 실패하였습니다", duration: 1.0, position: .center)
            }
        })
    }
    
    func editFeed() {
        guard let feedAddVC = UIStoryboard(name: "FeedAdd", bundle: nil).instantiateViewController(withIdentifier: "FeedAddViewController") as? FeedAddViewController else {return}
        feedAddVC.postIdx = self.postIdx
        
        feedAddVC.modalTransitionStyle = .coverVertical
        feedAddVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(feedAddVC, animated: true)
    }
    
    func checkDeleteFeed() {
        guard let feedDeleteVC = UIStoryboard(name: "FeedDelete", bundle: nil).instantiateViewController(withIdentifier: "FeedDeleteViewController") as? FeedDeleteViewController else {return}
        feedDeleteVC.postIdx = self.postIdx
        
        feedDeleteVC.modalTransitionStyle = .coverVertical
        feedDeleteVC.modalPresentationStyle = .fullScreen
        
        self.present(feedDeleteVC, animated: true)
        
    }
    
}
