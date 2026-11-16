//
//  NotificationModel.swift
//  Esterad
//
//  Created by Haneen on 09/12/2025.
//

import Foundation

struct NotificationResponse : Codable {
    let data : [NotificationModel]?
    let pagination : Pagination?
}

struct NotificationModel : Codable {
    let id: String?
      let title: String?
      let body: String?
      let type: String
      let createdAt: String?
      let data: NotificationData?
      
      enum CodingKeys: String, CodingKey {
          case id
          case title
          case body
          case type
          case createdAt = "created_at"
          case data
      }
}

extension NotificationModel {
    var notificationEnum: NotificationType? {
        return NotificationType(rawValue: type)
    }
}

// MARK: - Notification Data -

struct NotificationData: Codable {
    let guardValue: String?
    let orderId: String?
    let orderNum: String?
    let orderType: String?
    let delegateId: String?
    let delegateName: String?
    let type: NotificationType?

    enum CodingKeys: String, CodingKey {
        case guardValue = "guard"
        case orderId = "order_id"
        case orderNum = "order_num"
        case orderType = "order_type"
        case delegateId = "delegate_id"
        case delegateName = "delegate_name"
        case type
    }
}

// MARK: - Pagination -

struct Pagination: Codable {
    let countItems: Int?
    let currentPage: Int
    let nextPageURL: String?
    let perPage: Int?
    let pervPageURL: String?
    let totalItems: Int?
    let totalPages: Int
    var isLastPage: Bool {
        currentPage >= totalPages
    }
    
    
    enum CodingKeys: String, CodingKey {
        case countItems = "count_items"
        case currentPage = "current_page"
        case nextPageURL = "next_page_url"
        case perPage = "per_page"
        case pervPageURL = "perv_page_url"
        case totalItems = "total_items"
        case totalPages = "total_pages"
    }
}

struct NotificationCountResponse : Codable {
    let count : Int?
}
