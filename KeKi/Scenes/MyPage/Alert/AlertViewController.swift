//
//  AlertViewController.swift
//  KeKi
//
//  Created by 김초원 on 2023/02/01.
//

import UIKit

enum Todo {
    case logout
    case secession
}

class AlertViewController: UIViewController {

    // MARK: - Variables, IBOutlet, ...
    private var todo: Todo?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Methods of LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    // MARK: - Action Methods (IBAction, ...)
    @IBAction func didTapCancelButton(_ sender: UIButton) { dismiss(animated: true) }
    
    @IBAction func didTapconfirmButton(_ sender: UIButton) {
        // TODO: 로그아웃/탈퇴 기능 구현
        
    }
    
    
    // MARK: - Helper Methods (Setup Method, ...)
    func config(todo: Todo) { self.todo = todo }

    private func setupLayout() {
        
        containerView.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 15
        confirmButton.layer.cornerRadius = 15
        
        switch todo {
        case .logout:
            titleLabel.text = "로그아웃"
            contentLabel.text = "로그아웃 하시겠습니까?"
            confirmButton.titleLabel?.text = "로그아웃"
        case .secession:
            titleLabel.text = "회원탈퇴"
            contentLabel.text = "정말 케키와 헤어지실건가요? \n정말요?  진짜요? \n (해당 이메일로 재가입은 불가합니다.)"
            confirmButton.titleLabel?.text = "탈퇴하기"
        default:
            return
        }
    }

}

// MARK: - Extensions
