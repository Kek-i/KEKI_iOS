//
//  FeedCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

protocol AlertDelegate {
    func showFeedMainAlert()
    func showFeedDeclarationActionAlert()
}

class FeedCell: UITableViewCell {
    
    var feedAlertDelegate: AlertDelegate!
    
    var imageList: [String] = [
        "a.circle",
        "b.circle",
        "c.circle"
    ]

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCollectionView.register(UINib(nibName: "FeedImgsCell", bundle: nil), forCellWithReuseIdentifier: "FeedImgsCell")
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func didTapViewmoreButton(_ sender: UIButton) {
        print("didTapViewmoreButton")
        feedAlertDelegate.showFeedMainAlert()
    }
    
    @IBAction func didTapHeartButton(_ sender: UIButton) {
        heartButton.isSelected = !heartButton.isSelected
    }
    
    
    func setup() {
        
        
        imgCollectionView.isPagingEnabled = true
        imgCollectionView.dataSource = self
        imgCollectionView.delegate = self
        imgCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = imageList.count
        pageControl.currentPage = 0
    }
}

extension FeedCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedImgsCell", for: indexPath) as? FeedImgsCell else { return UICollectionViewCell() }
        return cell
    }
    
}

extension FeedCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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


