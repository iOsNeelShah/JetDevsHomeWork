//
//  MockUserDataStorage.swift
//  JetDevsHomeWorkTests
//
//  Created by Neel on 12/6/24.
//

import Foundation
@testable import JetDevsHomeWork

class MockUserDataStorage: UserDataStorageProtocol {
    
    var user: User?
    
    func getUser() -> User? {
        return user
    }
    
    func saveUser(user: User) {
        self.user = user
    }
    
    func removeUser() {
        self.user = nil
    }
}
