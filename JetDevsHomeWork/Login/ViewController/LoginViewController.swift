//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/5/24.
//

import MaterialComponents
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: LoginViewModel
    
    @IBOutlet weak var txtEmail: MDCOutlinedTextField!
    @IBOutlet weak var txtPassword: MDCOutlinedTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        validationBinding()
    }
    
    private func setUpUI() {
        txtEmail.label.text = "Email"
        txtPassword.label.text = "Password"
        txtEmail.setOutlineColor(UIColor(rgb: 0xBDBDBD, alpha: 0.5), for: .normal)
        txtPassword.setOutlineColor(UIColor(rgb: 0xBDBDBD, alpha: 0.5), for: .normal)
        txtEmail.setLeadingAssistiveLabelColor(.red, for: .normal)
        txtPassword.setLeadingAssistiveLabelColor(.red, for: .normal)
        txtEmail.setLeadingAssistiveLabelColor(.red, for: .editing)
        txtPassword.setLeadingAssistiveLabelColor(.red, for: .editing)
    }
    
    private func validationBinding() {
        txtEmail.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        
        viewModel.isEmailValid
            .subscribe(onNext: { [weak self] isValid in
                if isValid {
                    self?.txtEmail.leadingAssistiveLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isPasswordValid
            .subscribe(onNext: { [weak self] isValid in
                if isValid {
                    self?.txtPassword.leadingAssistiveLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.validateInput()
            .subscribe(onNext: { [weak self] isValid in
                self?.loginButton.isEnabled = isValid
                self?.updateButtonAppearance(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }
    
    // Action methods
    @objc private func emailTextChanged() {
        if let email = txtEmail.text {
            viewModel.email.onNext(email)
        }
    }
    
    @objc private func passwordTextChanged() {
        if let email = txtPassword.text {
            viewModel.password.onNext(email)
        }
    }
    
    @IBAction func loginButtonTapped() {
        self.view.endEditing(true)
    }
    
    @IBAction func closeButtonTap() {
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    // Private Methods
    
    // Method to update the button appearance based on its enabled state
    private func updateButtonAppearance(isEnabled: Bool) {
        if isEnabled {
            loginButton.backgroundColor = UIColor(rgb: 0x28518D)  // Button color when enabled
        } else {
            loginButton.backgroundColor = UIColor.lightGray    // Button color when disabled
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmail {
            guard let valid = try? viewModel.isEmailValid.value() else {
                return
            }
            if !valid {
                txtEmail.leadingAssistiveLabel.text = ValidationMessages.invalidEmail
            }
        } else {
            guard let valid = try? viewModel.isPasswordValid.value() else {
                return
            }
            if !valid {
                txtPassword.leadingAssistiveLabel.text = ValidationMessages.invalidPassword
            }
        }
    }
}
