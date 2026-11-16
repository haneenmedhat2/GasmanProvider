//
//  MerchantOrderModel.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import Foundation

struct MerchantOrdersResponse: Codable {
    let data: [MerchantOrder]
    let pagination: Pagination
}

struct MerchantOrder: Codable {
    let id: Int?
    let orderNum: String?
    let logo: String?
    let date: String?
    let time: String?
    let totalPrice: String?
    let currency: String?
    let status: String?
    let productsCategories: String?
    let totalMetalCylinders: Int?
    let totalFiberCylinders: Int?
    let userName: String?
    let location: String?
    let rejectReason: String?
    let productsType: String?
    let type : String?

    enum CodingKeys: String, CodingKey {
        case id, type
        case orderNum = "order_num"
        case logo, date, time
        case totalPrice = "total_price"
        case currency, status, location
        case productsCategories = "products_categories"
        case totalMetalCylinders = "total_metal_cylinders"
        case totalFiberCylinders = "total_fiber_cylinders"
        case userName = "user_name"
        case rejectReason = "reject_reason"
        case productsType = "products_type"
    }
}

enum MerchantOrderType {
    case receive
    case `return`

    var apiValue: String {
        switch self {
        case .receive: return "receive"
        case .return: return "return"
        }
    }

    var stringValue: String {
        switch self {
        case .receive: return "receive_orders".localized
        case .return: return "return_orders".localized
        }
    }
    
    var createOrderValue : Int {
        switch self {
        case .receive: return 1
        case .return: return 2
        }
    }
}
