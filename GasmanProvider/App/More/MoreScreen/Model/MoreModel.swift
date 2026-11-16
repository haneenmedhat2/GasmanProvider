//
//  MoreModel.swift
//  Esterad
//
//  Created by Haneen on 30/10/2025.
//

import Foundation
import UIKit

struct receivingOrderResponse : Codable {
    let canOrder : Bool?
    
    enum CodingKeys: String, CodingKey {
        case canOrder = "can_order"
    }
}

enum MoreMenuItem : CaseIterable {
    case availableForOrders
    case profile
    case settings
    case wallet
    case workLocation
    case termsAndConditions
    case aboutUs
    case privacyPolicy
    case contactUs
    case FAQ
    case complaints
    case myRatings
    case shareApp
    case logout
    case updateProfile
    case changephone
    case notifications
    case changePassword
    case changeLanguage
    case deleteAccount
    case insurance
    case statistics
    case introVideo
    case invoices
    case delegateRequests

    var icon : String {
        switch self {
        case .availableForOrders:
            return "available_orders"
        case .profile:
            return "profile"
        case .settings:
            return "settings"
        case .wallet:
            return "wallet"
        case .workLocation:
            return "location-share-02"
        case .termsAndConditions:
            return "terms"
        case .aboutUs:
            return "aboutUs"
        case .privacyPolicy:
            return "policy"
        case .contactUs:
            return "contactUs"
        case .FAQ:
            return "FQC"
        case .complaints:
            return "complaint"
        case .myRatings:
            return "rates"
        case .shareApp:
            return "share-08"
        case .logout:
            return "logout"
        case .updateProfile:
            return "settings"
        case .changephone:
            return "changePhone"
        case .notifications:
            return "fcm"
        case .changePassword:
            return "changePassword"
        case .changeLanguage:
            return "language-circle"
        case .deleteAccount:
            return "logout"
        case .insurance:
            return "wallet-add-02"
        case .statistics:
            return "left-to-right-list-number"
        case .introVideo:
            return "play-square"
        case .invoices:
            return "invoices"
        case .delegateRequests:
            return "delegateRequest"

        }
    }
    
    var title : String {
        switch self {
        case .availableForOrders:
            return "available_for_orders".localized
        case .profile:
            return "profile".localized
        case .settings:
            return "settings".localized
        case .wallet:
            return "wallet".localized
        case .workLocation:
            return "work_locations".localized
        case .termsAndConditions:
            return "terms_conditions".localized
        case .aboutUs:
            return "about_app".localized
        case .privacyPolicy:
            return "privacy_policy".localized
        case .contactUs:
            return "contact_us".localized
        case .FAQ:
            return "faq".localized
        case .complaints:
            return "complaints_suggestions".localized
        case .myRatings:
            return "my_ratings".localized
        case .shareApp:
            return "share_app".localized
        case .logout:
            return "logout".localized
        case .updateProfile:
            return "edit_profile".localized
        case .changephone:
            return "change_mobile_number".localized
        case .notifications:
            return "notifications".localized
        case .changePassword:
            return "change_password".localized
        case .changeLanguage:
            return "change_language".localized
        case .deleteAccount:
            return "delete_account".localized
        case .insurance:
            return "insurance_menu".localized
        case .statistics:
            return "reports".localized
        case .introVideo:
            return "intro_video".localized
        case .invoices:
            return "invoices".localized
        case .delegateRequests:
            return "delegate_registration_requests".localized
        }
    }
    
    var isSwitchHidden : Bool {
        switch self {
        case .notifications, .availableForOrders:
            return false
        default:
            return true
        }
    }

    var isIconHidden: Bool {
        switch self {
        case .availableForOrders:
            return true
        default:
            return false
        }
    }

    var backgroundColor : UIColor {
        switch self {
        case .logout, .deleteAccount, .availableForOrders:
            return .clear
        default:
            return UIColor.moreBG
        }
    }

    var fontColor : UIColor {
        switch self {
        case .logout, .deleteAccount:
            return .redFont
        case .availableForOrders:
            return .main
        default:
            return .black
        }
    }

    static func moreItems() -> [MoreMenuItem] {

        if Session.userType == .serviceProvider {
            return [.availableForOrders, .profile, .settings, .wallet, .statistics, .invoices, .delegateRequests, .termsAndConditions, .aboutUs, .privacyPolicy, .contactUs, .FAQ, .complaints, .introVideo, .logout]
        } else {
            return [.profile, .settings, .workLocation, .myRatings ,.statistics, .termsAndConditions, .aboutUs, .privacyPolicy, .contactUs, .FAQ, .complaints, .introVideo, .logout]
        }
    }
    
    static func settingsItems() -> [MoreMenuItem] {
            return [ .updateProfile ,.changephone ,.notifications , .changePassword,.changeLanguage , .deleteAccount]
    }
}
