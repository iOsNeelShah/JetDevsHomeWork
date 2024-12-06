//
//  LoginModel.swift
//  JetDevsHomeWork
//
//  Created by Neel on 12/5/24.
//

import Foundation

// Login request
struct LoginRequest: Encodable {
    
    let email: String
    let password: String
}

// Login response
struct LoginResponse: Decodable {
    
    let result: Int
    let errorMessage: String
    let userData: UserData?

    enum CodingKeys: String, CodingKey {
        case result
        case errorMessage = "error_message"
        case userData = "data"
    }
}

struct UserData: Decodable {
    
    let user: User?

    enum CodingKeys: String, CodingKey {
        case user
    }
}

struct User: Codable, Equatable {
    
    let userId: Int
    let userName: String
    let userProfileUrl: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userProfileUrl = "user_profile_url"
        case createdAt = "created_at"
    }
}
