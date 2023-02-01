//
//  ProductViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class ProductViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    var imgNum = 5
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupPageControl()
    }
    
    // MARK: - Action Methods (IBAction, ...)

    
    // MARK: - Helper Methods (Setup Method, ...)
    private func setupCollectionView() {
        imgCollectionView.isPagingEnabled = false
        imgCollectionView.showsHorizontalScrollIndicator = false
        imgCollectionView.dataSource = self
        imgCollectionView.delegate = self
        imgCollectionView.register(UINib(nibName: "ProductImgCell", bundle: nil), forCellWithReuseIdentifier: "ProductImgCell")

    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ellipsis.vertical"), style: .plain, target: self, action: #selector(didTapViewmoreButton))
    }
    
    @objc private func didTapViewmoreButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let changeAction = UIAlertAction(title: "상품 수정", style: .default)
        let deleteAction = UIAlertAction(title: "상품 삭제", style: .default)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        [
            changeAction,
            deleteAction,
            cancelAction
        ].forEach { alert.addAction($0) }
        
        present(alert, animated: true)
    }
    private func setupPageControl() {
        pageControl.numberOfPages = imgNum
        pageControl.currentPage = 0
    }
}

// MARK: - Extensions
extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImgCell", for: indexPath) as? ProductImgCell else { return UICollectionViewCell() }
        return cell
        
    }
    
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width/2)
        
        let newPage = Int(x / width)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}
