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
    @IBOutlet weak var btnLogin: UIButton!
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
        bindViewModel()
    }
    
    // MARK: - Private Methods
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
    
    private func bindViewModel() {
        // Bind loading indicator to ViewModel's isLoading
        viewModel.isLoading
            .subscribe(onNext: { [weak self] isLoading in
                DispatchQueue.main.async {
                    if isLoading {
                        self?.loadingIndicator.startAnimating()
                        self?.btnLogin.isEnabled = false
                    } else {
                        self?.loadingIndicator.stopAnimating()
                        self?.btnLogin.isEnabled = true
                    }
                }
                
            })
            .disposed(by: disposeBag)
        
        // Bind login success to navigate or show token
        viewModel.loginSuccess
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.sync {
                    self?.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        // Bind login error message to errorLabel
        viewModel.loginError
            .subscribe(onNext: { [weak self] errorMessage in
                DispatchQueue.main.sync {
                    self?.showAlert(message: errorMessage)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func validationBinding() {
        txtEmail.addTarget(self, action: #selector(emailTextChanged), for: .editingChanged)
        txtPassword.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        
        // Bind email field to ViewModel's isEmailValid
        viewModel.isEmailValid
            .subscribe(onNext: { [weak self] isValid in
                if isValid {
                    self?.txtEmail.leadingAssistiveLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        // Bind password field to ViewModel's isPasswordValid
        viewModel.isPasswordValid
            .subscribe(onNext: { [weak self] isValid in
                if isValid {
                    self?.txtPassword.leadingAssistiveLabel.text = ""
                }
            })
            .disposed(by: disposeBag)
        
        // Bind login button to ViewModel's validateInput
        viewModel.validateInput()
            .subscribe(onNext: { [weak self] isValid in
                self?.btnLogin.isEnabled = isValid
                self?.updateButtonAppearance(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }
    
    // Method to update the button appearance based on its enabled state
    private func updateButtonAppearance(isEnabled: Bool) {
        if isEnabled {
            btnLogin.backgroundColor = UIColor(rgb: 0x28518D)  // Button color when enabled
        } else {
            btnLogin.backgroundColor = UIColor.lightGray    // Button color when disabled
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Action Methods
    @objc private func emailTextChanged() {
        if let email = txtEmail.text {
            viewModel.email.onNext(email)
        }
    }
    
    @objc private func passwordTextChanged() {
        if let password = txtPassword.text {
            viewModel.password.onNext(password)
        }
    }
    
    @IBAction func loginButtonTapped() {
        self.view.endEditing(true)
        viewModel.login()
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
