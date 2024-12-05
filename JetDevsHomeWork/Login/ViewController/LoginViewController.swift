//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/5/24.
//

import MaterialComponents
import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        txtEmail.label.text = "Email"
        txtEmail.placeholder = "Email"
        txtPassword.label.text = "Password"
        txtPassword.placeholder = "Password"
        txtEmail.setOutlineColor(UIColor(rgb: 0xBDBDBD, alpha: 0.5), for: .normal)
        txtPassword.setOutlineColor(UIColor(rgb: 0xBDBDBD, alpha: 0.5), for: .normal)
    }
    
    // Action methods
    @IBAction func loginButtonTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonTap() {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
