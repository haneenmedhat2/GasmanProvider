//
//  ClientOrderModel.swift
//  GasmanProvider
//

import Foundation

struct ClientOrdersResponse: Codable {
    let data: [ClientOrder]
    let pagination: Pagination
}

struct ClientOrder: Codable {
    let id: Int?
    let orderNum: String?
    let logo: String?
    let userName: String?
    let date: String?
    let time: String?
    let totalPrice: String?
    let currency: String?
    let location: String?
    let status: ClientOrderStatusInfo?
    let payStatus: String?
    let productsType: String?
    let productsCategories: String?
    let acceptOrderButton: Bool?
    let refuseOrderButton: Bool?
    let rejectReason: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNum = "order_num"
        case logo
        case userName = "user_name"
        case date, time
        case totalPrice = "total_price"
        case currency, location, status
        case payStatus = "pay_status"
        case productsType = "products_type"
        case productsCategories = "products_categories"
        case acceptOrderButton = "accept_order_button"
        case refuseOrderButton = "refuse_order_button"
        case rejectReason = "reject_reason"
    }
}

struct ClientOrderStatusInfo: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?

    enum CodingKeys: String, CodingKey {
        case key, name, title
        case detailsText = "details_text"
    }
}

enum OrderStatus: String {
    case new
    case current
    case finished
    case cancel

    init(apiValue: String) {
        switch apiValue {
        case "finished": self = .finished
        case "current": self = .current
        default: self = .new
        }
    }

    var apiValue: String {
        switch self {
        case .new: return "new"
        case .current: return "current"
        case .finished: return "finished"
        case .cancel: return "cancel"
            
        }
    }

    var stringValue: String {
        switch self {
        case .new: return "new_orders".localized
        case .current: return "current_orders".localized
        case .finished: return "completed_orders".localized
        case .cancel: return "cancel"
        }
    }
}
