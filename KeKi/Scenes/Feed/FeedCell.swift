//
//  FeedCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit
import Kingfisher

protocol AlertDelegate {
    func showFeedMainAlert()
    func showFeedDeclarationActionAlert()
}

class FeedCell: UITableViewCell {
    
    var feedAlertDelegate: AlertDelegate!
    
    var imageList: [String] = []
    var tagList: [String] = []

    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var dessertNameButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var tag1Button: UIButton!
    @IBOutlet weak var tag2Button: UIButton!
    @IBOutlet weak var tag3Button: UIButton!
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgCollectionView.register(UINib(nibName: "FeedImgsCell", bundle: nil), forCellWithReuseIdentifier: "FeedImgsCell")
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        [tag1Button,tag2Button,tag3Button].forEach {
            $0?.layer.cornerRadius = 15
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func didTapViewmoreButton(_ sender: UIButton) {
        feedAlertDelegate.showFeedMainAlert()
    }
    
    @IBAction func didTapHeartButton(_ sender: UIButton) {
        heartButton.isSelected = !heartButton.isSelected
        heartButton.isSelected ? postLikeFeed() : discardFeedLike()
    }
    
    private func postLikeFeed() {
        // TODO: 피드 찜하기 기능
        print("찜 하기")
    }
    
    private func discardFeedLike() {
        // TODO: 피드 찜 취소하기 기능
        print("찜 취소")
    }
    
    func setSingleFeedView() { separatorView.isHidden = true }
    func reloadData() { imgCollectionView.reloadData() }
    
    func configure(data: Feed) {
        // set store profile
        nicknameLabel.text = data.storeName

        profileImgView.kf.setImage(with: URL(string: data.storeProfileImg))
        profileImgView.layer.cornerRadius = profileImgView.frame.width / 2
        
        profileImgView.layer.borderWidth = 0.3  // 정방형이 아닌 크기의 프로필 사진에 대한 임시처리
        profileImgView.layer.borderColor = UIColor.lightGray.cgColor    // 정방형이 아닌 크기의 프로필 사진에 대한 임시처리
        
        // set dessert contents
        imageList = data.postImgUrls
        pageControl.numberOfPages = imageList.count
        pageControl.currentPage = 0
        
        dessertNameButton.setTitle(data.dessertName, for: .normal)
        descriptionTextView.text = data.description
        
        tagList = data.tags
        setTagButton()
        
        if data.like { heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) }
    }
    
    func setup() {
        imgCollectionView.isPagingEnabled = true
        imgCollectionView.dataSource = self
        imgCollectionView.delegate = self
        imgCollectionView.showsHorizontalScrollIndicator = false
    }
    
    func setTagButton() {
        switch tagList.count {
        case 1:
            tag1Button.setTitle("# \(tagList[0])", for: .normal)
            [ tag2Button, tag3Button ].forEach { $0?.isHidden = true }
        case 2:
            tag1Button.setTitle("# \(tagList[0])", for: .normal)
            tag2Button.setTitle("# \(tagList[1])", for: .normal)
            [ tag3Button ].forEach { $0?.isHidden = true }
        case 3:
            tag1Button.setTitle("# \(tagList[0])", for: .normal)
            tag2Button.setTitle("# \(tagList[1])", for: .normal)
            tag3Button.setTitle("# \(tagList[2])", for: .normal)

        default:
            return
        }
    }
}

extension FeedCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedImgsCell", for: indexPath) as? FeedImgsCell else { return UICollectionViewCell() }
        let imgURL = imageList[indexPath.row]
        cell.imgView.kf.setImage(with: URL(string: imgURL))
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


