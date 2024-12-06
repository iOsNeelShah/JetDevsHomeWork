//
//  MockLoginService.swift
//  JetDevsHomeWorkTests
//
//  Created by Neel on 12/6/24.
//

@testable import JetDevsHomeWork
import RxSwift

// Mock Service to simulate login responses
class MockLoginService: LoginServiceProtocol {
    
    var shouldReturnError = false
    var customError: CustomError = .customMessage("Invalid credentials.")
    var mockUserResponse: User?
    var result = 1
    
    func login(loginRequest: LoginRequest) -> Observable<LoginResponse> {
        if shouldReturnError {
            return Observable.error(customError)
        }
        
        let response = LoginResponse(result: result, errorMessage: "", userData: UserData(user: mockUserResponse))
        return Observable.just(response)
    }
}
