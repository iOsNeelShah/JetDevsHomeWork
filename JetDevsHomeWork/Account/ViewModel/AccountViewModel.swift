//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/6/24.
//

import RxSwift

class AccountViewModel {
    
    private let userDataStorage: UserDataStorageProtocol
    
    // Observable that will emit the UserModel
    private let userSubject = BehaviorSubject<User?>(value: nil)
    
    // Public observable for the View to bind to
    var userObservable: Observable<User?> {
        return userSubject.asObservable()
    }
    
    init(userDataStorage: UserDataStorageProtocol) {
        self.userDataStorage = userDataStorage
    }
    
    // Load user data from local storage
    func loadUser() {
        if let user = userDataStorage.getUser() {
            userSubject.onNext(user)
        }
    }
    
    func logoutUser() {
        userDataStorage.removeUser()
        userSubject.onNext(nil)
    }
}
