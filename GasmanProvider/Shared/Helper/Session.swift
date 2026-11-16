//
//  Session.swift
//  Esterad
//
//  Created by Haneen on 13/01/2026.
//
import Foundation

struct Session {
    static var token: String? {
        get {
            return UserDefaults.accessToken
        }
        set {
            UserDefaults.accessToken = newValue
        }
    }
    
    static var isLogin: Bool? {
        get {
            return UserDefaults.isLogin
        }
        set {
            UserDefaults.isLogin = newValue ?? true
        }
    }
    
    static var user: User? {
        get {
            return UserDefaults.user
        }
        set {
            UserDefaults.user = newValue
        }
    }

    static var userType: UserType? {
        get { UserDefaults.userType }
        set { UserDefaults.userType = newValue }
    }

    static var provider: Provider? {
        get { UserDefaults.provider }
        set { UserDefaults.provider = newValue }
    }
}
