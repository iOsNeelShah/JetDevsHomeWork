//
//  LoginViewModelTests.swift
//  JetDevsHomeWorkTests
//
//  Created by Neel on 12/6/24.
//

@testable import JetDevsHomeWork
import RxSwift
import XCTest

class LoginViewModelTests: XCTestCase {
    
    var viewModel: LoginViewModel!
    var mockLoginService: MockLoginService!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        mockLoginService = MockLoginService()
        viewModel = LoginViewModel(loginService: mockLoginService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockLoginService = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // Test email validation
    func testEmailValidation_whenValidEmail_isValid() {
        // Given a valid email
        let validEmail = "test@example.com"
        
        // When the email is updated
        viewModel.email.onNext(validEmail)
        
        // Then isEmailValid should be true
        viewModel.isEmailValid
            .subscribe(onNext: { isValid in
                XCTAssertTrue(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    func testEmailValidation_whenInvalidEmail_isInvalid() {
        // Given an invalid email
        let invalidEmail = "invalid-email"
        
        // When the email is updated
        viewModel.email.onNext(invalidEmail)
        
        // Then isEmailValid should be false
        viewModel.isEmailValid
            .subscribe(onNext: { isValid in
                XCTAssertFalse(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    // Test password validation
    func testPasswordValidation_whenValidPassword_isValid() {
        // Given a valid password
        let validPassword = "password123"
        
        // When the password is updated
        viewModel.password.onNext(validPassword)
        
        // Then isPasswordValid should be true
        viewModel.isPasswordValid
            .subscribe(onNext: { isValid in
                XCTAssertTrue(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    func testPasswordValidation_whenInvalidPassword_isInvalid() {
        // Given an invalid password
        let invalidPassword = "123"
        
        // When the password is updated
        viewModel.password.onNext(invalidPassword)
        
        // Then isPasswordValid should be false
        viewModel.isPasswordValid
            .subscribe(onNext: { isValid in
                XCTAssertFalse(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    // Test login success
    func testLogin_whenCredentialsAreValid_shouldReturnSuccess() {
        // Given valid email and password
        let validEmail = "test@example.com"
        let validPassword = "password123"
        viewModel.email.onNext(validEmail)
        viewModel.password.onNext(validPassword)
        
        // Simulate a successful login
        mockLoginService.result = 1
        mockLoginService.mockUserResponse = User(userId: 1,
                                                 userName: "Test",
                                                 userProfileUrl: "",
                                                 createdAt: "")
        
        // When the login method is called
        viewModel.login()
        
        // Then the loginSuccess should be triggered
        viewModel.loginSuccess
            .subscribe(onNext: {
                XCTAssertTrue(true)  // Login success scenario
            })
            .disposed(by: disposeBag)
    }
    
    // Test login failure
    func testLogin_whenCredentialsAreInvalid_shouldReturnError() {
        // Given invalid email and password
        let invalidEmail = "invalid@example.com"
        let invalidPassword = "short"
        viewModel.email.onNext(invalidEmail)
        viewModel.password.onNext(invalidPassword)
        
        // Simulate a failed login due to incorrect credentials
        mockLoginService.result = 0
        mockLoginService.mockUserResponse = nil
        
        // When the login method is called
        viewModel.login()
        
        // Then the loginError should be triggered
        viewModel.loginError
            .subscribe(onNext: { errorMessage in
                XCTAssertEqual(errorMessage, "Invalid credentials")
            })
            .disposed(by: disposeBag)
    }
    
    // Test login error handling (network error)
    func testLogin_whenNetworkErrorOccurs_shouldReturnError() {
        // Given valid email and password
        let validEmail = "test@example.com"
        let validPassword = "password123"
        viewModel.email.onNext(validEmail)
        viewModel.password.onNext(validPassword)
        
        // Simulate network error
        mockLoginService.shouldReturnError = true
        
        // When the login method is called
        viewModel.login()
        
        // Then the loginError should be triggered
        viewModel.loginError
            .subscribe(onNext: { errorMessage in
                XCTAssertEqual(errorMessage, "Network Error")
            })
            .disposed(by: disposeBag)
    }
    
    // Test input validation combined
    func testValidateInput_whenAllInputsAreValid_shouldReturnTrue() {
        // Given valid email and password
        let validEmail = "test@example.com"
        let validPassword = "password123"
        viewModel.email.onNext(validEmail)
        viewModel.password.onNext(validPassword)
        
        // When the input is validated
        viewModel.validateInput()
            .subscribe(onNext: { isValid in
                XCTAssertTrue(isValid)
            })
            .disposed(by: disposeBag)
    }
    
    func testValidateInput_whenInputsAreInvalid_shouldReturnFalse() {
        // Given invalid email and password
        let invalidEmail = "invalid-email"
        let invalidPassword = "123"
        viewModel.email.onNext(invalidEmail)
        viewModel.password.onNext(invalidPassword)
        
        // When the input is validated
        viewModel.validateInput()
            .subscribe(onNext: { isValid in
                XCTAssertFalse(isValid)
            })
            .disposed(by: disposeBag)
    }
}
