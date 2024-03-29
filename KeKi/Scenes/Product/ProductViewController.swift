//
//  ProductViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/01/31.
//

import UIKit

class ProductViewController: UIViewController {

    var dessertIdx: Int?
    var dessertImg: [Post] = []
    
    // MARK: - Variables, IBOutlet, ...
    @IBOutlet weak var isImageEmptyView: UIView!
    
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
        fetchData()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
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
        self.navigationController?.isNavigationBarHidden = false
        let menuButton =  UIBarButtonItem(image: UIImage(named: "ellipsis.vertical"), style: .plain, target: self, action: #selector(didTapViewmoreButton))
        menuButton.tintColor = .black
        
        let backButton = UIBarButtonItem(image: UIImage(named: "chevron-right"), style: .plain, target: self, action: #selector(backToScreen))
        backButton.tintColor = .black
        
        self.navigationItem.rightBarButtonItem = menuButton
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    private func checkImageNone() {
        if dessertImg.count == 0 { isImageEmptyView.isHidden = false }
        else { isImageEmptyView.isHidden = true }
    }
    
    @objc private func didTapViewmoreButton() {
        // TODO: 판매자에게만 보이도록 수정 필요
        if APIManeger.shared.getHeader() != nil && APIManeger.shared.getUserInfo()?.role == "판매자" {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let changeAction = UIAlertAction(title: "상품 수정", style: .default) { _ in
                self.editProduct()
            }
            let deleteAction = UIAlertAction(title: "상품 삭제", style: .default) { _ in
                self.deleteProduct()
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            [
                changeAction,
                deleteAction,
                cancelAction
            ].forEach { alert.addAction($0) }
            
            present(alert, animated: true)
        }
    }
    
    
    @objc private func backToScreen() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = dessertImg.count
        pageControl.currentPage = 0
    }
    
    
    private func editProduct() {
        guard let productAddVC = UIStoryboard(name: "ProductAdd", bundle: nil).instantiateViewController(withIdentifier: "ProductAddViewController") as? ProductAddViewController else {return}
        productAddVC.dessertIdx = self.dessertIdx
        
        productAddVC.modalTransitionStyle = .coverVertical
        productAddVC.modalPresentationStyle = .fullScreen
        
        self.navigationController?.pushViewController(productAddVC, animated: true)
    }
    
    private func deleteProduct() {
        APIManeger.shared.testDeleteData(urlEndpointString: "/desserts/\(dessertIdx!)") { [weak self] response in
            if response.isSuccess == true {
                let alert = UIAlertController(title: "삭제 완료", message: "정상적으로 상품이 삭제되었습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                self?.present(alert, animated: true)
            }
        }
    }
}

// MARK: - Extensions
extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dessertImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImgCell", for: indexPath) as? ProductImgCell else { return UICollectionViewCell() }
        
        if dessertImg.count == 0 { return cell }
        else {
            if dessertImg[indexPath.row].imgUrl.contains("https:") {
                // https:...형태의 Url
                cell.imageView.kf.setImage(with: URL(string: dessertImg[indexPath.row].imgUrl))
            } else {
                // 디렉토리 형태의 Url
                let _ = FirebaseStorageManager.downloadImage(urlString: dessertImg[indexPath.row].imgUrl, completion: { img in
                   cell.imageView.image = img
                })
            }
            
            cell.imageView.contentMode = .scaleAspectFit
            return cell
        }
    }
    
}

extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if dessertImg.count > 1 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 60)
        } else {
            // 보여줄 디저트 이미지가 1개인 경우 중앙 정렬 되도록 inset 설정
            return UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.bounds.size.height
        let x = scrollView.contentOffset.x + (height/2)
        
        let newPage = Int(x / height)
        if pageControl.currentPage != newPage {
            pageControl.currentPage = newPage
        }
    }
}


extension ProductViewController {
    private func fetchData() {
        APIManeger.shared.testGetData(urlEndpointString: "/desserts/\(dessertIdx!)",
                                      dataType: ProductsResponse.self,
                                      parameter: nil,
                                      completionHandler: { [weak self] response in
            
            
            if let result = response.result {
                print(result)
                
                self?.dessertImg = result.images
                self?.nameLabel.text = result.nickname
                self?.priceLabel.text = String(result.dessertPrice)
                self?.descriptionTextView.text = result.dessertDescription
                
                self?.setupPageControl()
                self?.imgCollectionView.reloadData()
                self?.checkImageNone()
            }
        })
    }
}
