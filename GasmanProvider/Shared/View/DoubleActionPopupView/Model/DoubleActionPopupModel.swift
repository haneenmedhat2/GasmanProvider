//
//  DoubleActionPopupModel.swift
//  Esterad
//
//  Created by Haneen on 05/11/2025.
//

import Foundation
import UIKit

enum DoubleActionPopupType {
    case deleteAccount
    case deleteAddress
    case deleteNotifications

    
    var title: String {
        switch self {
        case .deleteAccount:
            return "confirm_delete_account".localized
        case .deleteAddress:
            return "confirm_delete_address".localized
        case .deleteNotifications:
            return "confirm_delete_notification".localized
        }
    }
    

    var firstBtnTitle: String {
        switch self {
        case .deleteAccount ,.deleteNotifications:
            return "back".localized
        case .deleteAddress:
            return "cancel".localized
        }
    }
    
    var firstBtnColor : UIColor {
        switch self {
        case .deleteAccount , .deleteNotifications:
            return .main
        case .deleteAddress:
            return .black
        }
    }
    
    var secBtnTitle: String {
        switch self {
        case .deleteAccount, .deleteAddress ,.deleteNotifications:
            return "delete".localized
        }
    }
    
}
