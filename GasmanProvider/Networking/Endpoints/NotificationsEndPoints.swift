//
//  NotificationsEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 05/09/2025.
//

import Foundation
import Alamofire

struct NotificationsEndPoints {
    private init() {}
}

extension NotificationsEndPoints {
    
    
    static func notificationCount() -> Endpoint<BaseResponse<NotificationCountResponse>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/count-notifications",
            headerType:.authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getNotifications(page: Int) -> Endpoint<BaseResponse<NotificationResponse>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/notifications",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func deleteNotification(notificationId:String) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .delete,
            path: "\(prefix)/delete-notification/\(notificationId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func deleteAllNotifications() -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .delete,
            path: "\(prefix)/delete-notifications",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}

