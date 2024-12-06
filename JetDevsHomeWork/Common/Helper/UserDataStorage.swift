//
//  UserDataStorage.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/6/24.
//

import Foundation

class UserDataStorage {
    
    static let shared = UserDataStorage()
    
    private let userKey = "userStoreKey"
    
    // Save the user model to UserDefaults
    func saveUser(user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
    
    // Retrieve the user model from UserDefaults
    func getUser() -> User? {
        if let savedUserData = UserDefaults.standard.data(forKey: userKey),
           let user = try? JSONDecoder().decode(User.self, from: savedUserData) {
            return user
        }
        return nil
    }
    
    func removeUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
