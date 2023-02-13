//
//  HomeTableViewCell.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/07.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
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
        // TODO: 태그별 더보기 버튼 탭 이벤트 처리 메소드 정의 필요
        print("did tap view more button")
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
        return 5 // default number
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
        // TODO: 각 태그별 스토어 게시물 탭 이벤트 처리 메소드 정의 필요
        print("tapped store post :: indexPath --> \(indexPath)")
    }
}
