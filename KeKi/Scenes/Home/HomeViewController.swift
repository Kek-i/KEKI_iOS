//
//  HomeViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...

    var ddayCountingText: String? = "베이님! \n투리 생일이 3일 남았어요! \n특별한 하루를 준비해요"

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var ddayCountingLabel: UILabel!
    
    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var middleTagContainerView: UIView!
    @IBOutlet weak var bottomTagContainerView: UIView!
    
    @IBOutlet weak var topCollectionView: UICollectionView!
    @IBOutlet weak var middleCollectionView: UICollectionView!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = false
        setup()
        setupLayout()
        setUpDdayCountingLabel()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapViewMoreButton(_ sender: UIButton) {
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setup() {
        [
            topCollectionView,
            middleCollectionView,
            bottomCollectionView
            
        ].forEach {
            $0?.indicatorStyle = .white
            $0?.dataSource = self
            $0?.delegate = self
        }
    }
    private func setupLayout() {
        [
            tagContainerView,
            middleTagContainerView,
            bottomTagContainerView
        ].forEach {
            $0?.layer.cornerRadius = 18
        }
    }
    private func setUpDdayCountingLabel() {
        let attributedString = NSMutableAttributedString(string: ddayCountingText!)
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = 8 
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        ddayCountingLabel.attributedText = attributedString
    }

}

// MARK: - Extensions
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // default number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        cell.setupLayout()
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true     // 스크린 맨 위를 누르면 가장 상단으로 이동
    }
}
