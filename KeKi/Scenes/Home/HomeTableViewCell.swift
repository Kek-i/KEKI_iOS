//
//  HomeTableViewCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import UIKit

protocol TagDetailDelegate {
    func tapTagAction(tagTitle: String)
}

class HomeTableViewCell: UITableViewCell {
    var tagDetailDelegate: TagDetailDelegate? = nil
    private var storePostList: [HomePostRes] = []

    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var tagTitleLabel: UILabel!
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didTapViewMoreButton(_ sender: UIButton) {
        tagDetailDelegate?.tapTagAction(tagTitle: tagTitleLabel.text!)
    }
    
    func configure() {
        setupCollectionView()
        setupLayout()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
    }
    
    private func setupLayout() {
        selectionStyle = .none
        tagContainerView.layer.cornerRadius = 18
    }
    
    func setData(sectionData: HomeTagRes) {
        tagTitleLabel.text = "# " + sectionData.tagName
        storePostList = sectionData.homePostRes
    }
    
    func reloadCell() {
        collectionView.reloadData()
    }
}

extension HomeTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return storePostList.count 
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        if (storePostList.count > 0) && (storePostList.count > indexPath.row){
            cell.setData(storeData: storePostList[indexPath.row])
        }
        cell.setupLayout()
        return cell
    }
}

extension HomeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped store post :: indexPath --> \(indexPath)")
        
        // TODO: 각 태그별 스토어 게시물 탭 이벤트 처리 메소드 정의 필요
        // 탭 이벤트가 발생한 게시물의 인덱스 정보 (postIdx)를 피드 상세를 보여주는 셀에 넘겨주고
        // 피드 상세 셀에서 받은 postIdx를 통해 서버에서 피드 정보 불러오기
        
        let storyboard = UIStoryboard.init(name: "Feed", bundle: nil)
        guard let feedViewController = storyboard.instantiateViewController(withIdentifier: "FeedViewController") as? FeedViewController else { return }

        feedViewController.postIdx = storePostList[indexPath.row].postIdx
        if let vc = self.next(ofType: UIViewController.self) {
            vc.tabBarController?.tabBar.isHidden = true
            vc.navigationController?.navigationBar.isHidden = false
            vc.navigationController?.isNavigationBarHidden = false
            vc.navigationController?.pushViewController(feedViewController, animated: true)


        }

    }
}

