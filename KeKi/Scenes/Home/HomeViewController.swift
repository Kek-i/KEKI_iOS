//
//  HomeViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/29.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
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
        setup()
        setupLayout()
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
            $0?.layer.cornerRadius = 20
        }
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
    
}
