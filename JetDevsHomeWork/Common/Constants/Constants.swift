//
//  Constants.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit

let screenFrame: CGRect = UIScreen.main.bounds
let screenWidth = screenFrame.size.width
let screenHeight = screenFrame.size.height

let isIPhoneX = (screenWidth >= 375.0 && screenHeight >= 812.0) ? true : false
let isIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad ? true : false

let statusBarHeight: CGFloat = isIPhoneX ? 44.0 : 20.0
let navigationBarHeight: CGFloat = 44.0
let statusBarNavigationBarHeight: CGFloat = isIPhoneX ? 88.0 : 64.0

let tabbarSafeBottomMargin: CGFloat = isIPhoneX ? 34.0 : 0.0
let tabBarHeight: CGFloat = isIPhoneX ? (tabBarTrueHeight+34.0) : tabBarTrueHeight
let tabBarTrueHeight: CGFloat = 49.0

let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"

struct AppURLs {
    
    static let mainUrl = "https://jetdevs.wiremockapi.cloud/"
    
    static let login = mainUrl + "login"
}

struct ValidationMessages {
    
    static let invalidEmailPassword = "Please enter valid email or password."
    static let enterEmail = "Please enter email."
    static let invalidEmail = "Please enter valid email."
    static let invalidPassword = "Password must be at least 6 characters long."
    static let enterPassword = "Please enter password."
}

struct APIErrorMessages {
    
    static let invalidUrl = "The URL is invalid."
    static let serverError = "Server error, Please try again."
    static let somethingWrongError  = "Something went wrong, Please try again."
    static let invalidCredential = "Invalid credentials."
    static let unexpectedError = "Unexpected error occurred, Please try again."
}
