//
//  NSNotificationNames.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

extension NSNotification.Name {
    
    /*
     Enum for Holding all strings keys as rawValues to avoid using Strings
     */
    
    private enum Names: String {
        case order
        case complaints
        case block
        case shouldExitChatAndGoToOrderDetails
        case appDidBecomeActive
        case cart
        
    }
    
    /*
     All Notification cases
     */
    
    static let isOrderChanged = Notification.Name(rawValue: Names.order.rawValue)
    static let isComplaintsChanged = Notification.Name(rawValue: Names.complaints.rawValue)
    static let shouldExitChatAndGoToOrderDetails = Notification.Name(rawValue: Names.shouldExitChatAndGoToOrderDetails.rawValue)
    static let appDidBecomeActive = Notification.Name(rawValue: Names.appDidBecomeActive.rawValue)
    static let isCartChanged = Notification.Name(rawValue: Names.cart.rawValue)

}

