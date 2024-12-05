//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/5/24.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    private let loginService: LoginServiceProtocol
    private let disposeBag = DisposeBag()
    
    // Inputs
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    
    // Outputs
    let isLoading = BehaviorSubject<Bool>(value: false)
    let loginSuccess = PublishSubject<Void>()
    let loginError = PublishSubject<String>()
    let isEmailValid = BehaviorSubject<Bool>(value: false)
    let isPasswordValid = BehaviorSubject<Bool>(value: false)
    
    init(loginService: LoginServiceProtocol) {
        self.loginService = loginService
        bindingValidation()
    }
    
    private func bindingValidation() {
        email
            .skip(1)  // Skip the first value emitted (initial value)
            .map { self.isValidEmail($0) }
            .subscribe(onNext: { [weak self] isValid in
                self?.isEmailValid.onNext(isValid)
            })
            .disposed(by: disposeBag)
        
        password
            .skip(1)
            .map { self.isValidPassword($0) }
            .subscribe(onNext: { [weak self] isValid in
                self?.isPasswordValid.onNext(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    func login() {
        guard let email = try? self.email.value(), let password = try? self.password.value() else {
            // Handle case where values are not available
            self.loginError.onNext(ValidationMessages.invalidEmailPassword)
            return
        }
        self.isLoading.onNext(true)
        return self.loginService.login(loginRequest:
                                        LoginRequest(email: email,
                                                     password: password))
        .subscribe(onNext: { [weak self] response in
            self?.isLoading.onNext(false)
            if response.result == 1 {
                self?.loginSuccess.onNext(())
            } else {
                self?.loginError.onNext(response.errorMessage)
            }
        }, onError: { error in
            self.isLoading.onNext(false)
            if let loginError = error as? CustomError {
                self.loginError.onNext(loginError.localizedDescription)
            }
            
        })
        .disposed(by: disposeBag)
    }
    
    // Function to validate email and password
    func validateInput() -> Observable<Bool> {
        return Observable.combineLatest(email.asObservable(), password.asObservable())
            .map { email, password in
                return self.isValidEmail(email) && self.isValidPassword(password)
            }
    }
    
    // Function to validate email format using regex
    private func isValidEmail(_ email: String) -> Bool {
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    // Function to validate password: at least 6 characters
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
