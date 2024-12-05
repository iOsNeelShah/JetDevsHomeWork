//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/5/24.
//

import Foundation
import RxSwift

class LoginViewModel {
    
    private let disposeBag = DisposeBag()
    
    // Inputs
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    
    // Outputs
    let isEmailValid = BehaviorSubject<Bool>(value: false)
    let isPasswordValid = BehaviorSubject<Bool>(value: false)
    
    init() {
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
