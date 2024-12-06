//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import RxSwift
import Kingfisher

class AccountViewController: UIViewController {
    
    @IBOutlet weak var nonLoginView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headImageView: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel = AccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        viewModel.loadUser()
        
        // Bind the user observable to the UI labels
        viewModel.userObservable
            .subscribe(onNext: { [weak self] user in
                DispatchQueue.main.async {
                    if let user = user {
                        self?.nameLabel.text = user.userName
                        self?.headImageView.kf.setImage(with: URL(string: user.userProfileUrl),
                                                        placeholder: UIImage(imageLiteralResourceName: "Avatar"))
                        self?.daysLabel.text = "Created \(user.createdAt.daysAgo() ?? "")"
                        self?.nonLoginView.isHidden = true
                        self?.loginView.isHidden = false
                    } else {
                        self?.nonLoginView.isHidden = false
                        self?.loginView.isHidden = true
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func loginButtonTap(_ sender: UIButton) {
        let loginService = LoginService()
        let loginViewModel = LoginViewModel(loginService: loginService)
        let loginViewController = LoginViewController(viewModel: loginViewModel)
        
        loginViewController.loginTrigger
            .subscribe(onNext: { [weak self] in
                self?.viewModel.loadUser()
            })
            .disposed(by: disposeBag)
        
        loginViewController.modalPresentationStyle = .fullScreen
        self.present(loginViewController, animated: true)
    }
    
    @IBAction func logoutButtonTap() {
        viewModel.logoutUser()
    }
}
