//
//  FeedViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class FeedViewController: UIViewController {
    // MARK: - Variables, IBOutlet, ...
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        setupNavigationBar()
        setupTableView()
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "피드"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: nil)
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FeedCell", bundle: nil), forCellReuseIdentifier: "FeedCell")

    }
    
}

// MARK: - Extensions
extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath)
                as? FeedCell else { return UITableViewCell() }
        cell.setup()
        cell.feedAlertDelegate = self
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