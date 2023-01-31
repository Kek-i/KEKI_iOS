//
//  FeedCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class FeedCell: UITableViewCell {
    
    var imageList: [String] = [
        "a.circle",
        "b.circle",
        "c.circle"
    ]

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCollectionView.register(UINib(nibName: "FeedImgsCell", bundle: nil), forCellWithReuseIdentifier: "FeedImgsCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
//        cakeImageView.image = UIImage(systemName: imageList[pageControl.currentPage])
    }
    
    
    @IBAction func didTapViewmoreButton(_ sender: UIButton) {
        // TODO: popVC 또는 dismiss 처리
    }
    
    func setup() {
        imgCollectionView.isPagingEnabled = true
        imgCollectionView.dataSource = self
        imgCollectionView.delegate = self
        imgCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setupPageControl() {
        //페이지 컨트롤의 전체 페이지를 images 배열의 전체 개수 값으로 설정
        pageControl.numberOfPages = imageList.count
        // 페이지 컨트롤의 현재 페이지를 0으로 설정
        pageControl.currentPage = 0
//        cakeImageView.image = UIImage(systemName: imageList[0])
    }
}

extension FeedCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
}
