//
//  UserType.swift
//  GasmanProvider
//

import Foundation

enum UserType: String, Codable {
    case delegate_ = "delegate"
    case serviceProvider = "service_provider"

    var displayName: String {
        switch self {
        case .delegate_: return "user_type_delegate".localized
        case .serviceProvider: return "user_type_service_provider".localized
        }
    }
}
