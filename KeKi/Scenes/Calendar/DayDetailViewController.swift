//
//  DayDetailViewController.swift
//  KeKi
//
//  Created by 유상 on 2023/02/02.
//

import UIKit

class DayDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    
    @IBOutlet weak var hashTagCV: UICollectionView!
    
    @IBOutlet weak var dayTypeLabel: UILabel!
    @IBOutlet weak var dateTextButton: UIButton!
    
    @IBOutlet weak var findCakeButton: UIButton!
    
    let colorList: Array<UIColor> = [
        UIColor(red: 252.0 / 255.0, green: 244.0 / 255.0, blue: 223.0 / 255.0, alpha: 1),
        UIColor(red: 250.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1),
        UIColor(red: 244.0 / 255.0, green: 203.0 / 255.0, blue: 203.0 / 255.0, alpha: 1)
    ]
    
    // 서버 연결 후 삭제 - 임시 데이터
    let hashTagList: Array<String> = ["친구", "기념일", "가족"]
    
    var totalWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupLayout()
        setupNavigationBar()
    }
    
    func setup() {
        hashTagCV.delegate = self
        hashTagCV.dataSource = self
        
        hashTagCV.showsHorizontalScrollIndicator = true
    }
    
    func setupLayout() {
        [dateTextButton, findCakeButton].forEach { btn in
            btn.layer.cornerRadius = 10
            
            btn.layer.shadowColor = CGColor(red: 152.0 / 255.0, green: 113.0 / 255.0, blue: 113.0 / 255.0, alpha: 0.15)
            btn.layer.shadowOffset = CGSize(width: 3, height: 3)
            btn.layer.shadowRadius = 4
            btn.layer.shadowOpacity = 1.0
        }
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back"), style: .done, target: self, action: #selector(moveToCalendar))
        backButton.tintColor = .black
        
        let editButton = UIBarButtonItem(image: UIImage(named: "edit"), style: .done, target: self, action: #selector(moveToEdit))
        editButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func moveToCalendar() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moveToEdit() {
        guard let editVC = UIStoryboard(name: "DayAddViewController", bundle: nil).instantiateViewController(withIdentifier: "DayAddViewController") as? DayAddViewController else {return}
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    
    @IBAction func findCake(_ sender: Any) {
    }
    
}

extension DayDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hashTagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HashTagCell", for: indexPath)
        
        if let hashTagCell = cell as? HashTagCell {
            hashTagCell.backgroundColor = colorList[indexPath.row % 3]
            hashTagCell.setHashTagLabel(hashTag: "# " + hashTagList[indexPath.row])
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelTmp = UILabel()
        labelTmp.text = "# " + hashTagList[indexPath.row]
        
        totalWidth = totalWidth + labelTmp.intrinsicContentSize.width
        
        return CGSize(width: labelTmp.intrinsicContentSize.width, height: 26)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // collection view 가운데 정렬
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        let totalSpacingWidth = CGFloat(10 * (hashTagList.count - 1))

        let leftInset = (collectionView.layer.frame.size.width - (totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset-20, bottom: 0, right: rightInset-20)

    }

}


