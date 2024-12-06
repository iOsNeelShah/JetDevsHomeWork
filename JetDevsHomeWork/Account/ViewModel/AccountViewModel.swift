//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/6/24.
//

import RxSwift

class AccountViewModel {
    
    // Observable that will emit the UserModel
    private let userSubject = BehaviorSubject<User?>(value: nil)
    
    // Public observable for the View to bind to
    var userObservable: Observable<User?> {
        return userSubject.asObservable()
    }
    
    // Load user data from local storage
    func loadUser() {
        if let user = UserDataStorage.shared.getUser() {
            userSubject.onNext(user)
        }
    }
    
    func logoutUser() {
        UserDataStorage.shared.removeUser()
        userSubject.onNext(nil)
    }
}
