//
//  AccountViewModelTests.swift
//  JetDevsHomeWorkTests
//
//  Created by Neel on 12/6/24.
//

@testable import JetDevsHomeWork
import RxSwift
import XCTest

final class AccountViewModelTests: XCTestCase {
    
    var viewModel: AccountViewModel!
    var mockUserDataStorage: MockUserDataStorage!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
        // Initialize the mock user storage
        mockUserDataStorage = MockUserDataStorage()
        
        // Create the ViewModel, injecting the mock user data storage
        viewModel = AccountViewModel(userDataStorage: mockUserDataStorage)
    }
    
    override func tearDown() {
        viewModel = nil
        mockUserDataStorage = nil
        disposeBag = nil
        super.tearDown()
    }
    
    // Test loading user data
    func testLoadUser_whenUserExists_shouldEmitUser() {
        // Given a user exists in the mock storage
        let expectedUser = User(userId: 1, userName: "Test", userProfileUrl: "", createdAt: "")
        mockUserDataStorage.saveUser(user: expectedUser)
        
        // Create an expectation to wait for the user to be emitted
        let expectation = self.expectation(description: "User emitted")
        
        // Subscribe to the userObservable to receive the emitted user
        var emittedUser: User?
        viewModel.userObservable
            .skip(1)
            .subscribe(onNext: { user in
                emittedUser = user
                expectation.fulfill() // Fulfill expectation when a user is emitted
            })
            .disposed(by: disposeBag)
        
        // When loadUser is called
        viewModel.loadUser()
        
        // Wait for the async expectation to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then check if the emitted user matches the expected user
        XCTAssertEqual(emittedUser, expectedUser)
    }
    
    // Test logout user
    func testLogoutUser_whenUserIsLoggedIn_shouldEmitNil() {
        // Given a user is in storage
        let user = User(userId: 1, userName: "Test", userProfileUrl: "", createdAt: "")
        mockUserDataStorage.saveUser(user: user)
        
        // Create an expectation to wait for the nil emission after logout
        let expectation = self.expectation(description: "Nil emitted after logout")
        
        // Subscribe to the userObservable to receive the emitted user
        var emittedUser: User?
        viewModel.userObservable
            .skip(1)
            .subscribe(onNext: { user in
                emittedUser = user
                expectation.fulfill() // Fulfill the expectation after emission
            })
            .disposed(by: disposeBag)
        
        // When logoutUser is called
        viewModel.logoutUser()
        
        // Wait for the async expectation to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then check if the emitted value is nil (user is logged out)
        XCTAssertNil(emittedUser)
    }
    
    // Test loading user when no user exists
    func testLoadUser_whenNoUserExists_shouldEmitNil() {
        // Given no user exists in storage
        mockUserDataStorage.removeUser()
        
        // Create an expectation to wait for the nil emission
        let expectation = self.expectation(description: "Nil emitted when no user exists")
        
        // Subscribe to the userObservable to receive the emitted user
        var emittedUser: User?
        viewModel.userObservable
            .subscribe(onNext: { user in
                emittedUser = user
                expectation.fulfill() // Fulfill expectation when nil is emitted
            })
            .disposed(by: disposeBag)
        
        // When loadUser is called
        viewModel.loadUser()
        
        // Wait for the async expectation to be fulfilled
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then check if the emitted value is nil (no user)
        XCTAssertNil(emittedUser)
    }
    
}
