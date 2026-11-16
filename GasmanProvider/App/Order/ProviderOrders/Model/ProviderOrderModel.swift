//
//  ProviderOrderModel.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import Foundation

struct ProviderOrdersResponse: Codable {
    let orders: [ProviderOrder]?
    let pagination: Pagination?
}

struct ProviderOrder: Codable {
    let id: Int?
    let orderNum: String?
    let image: String?
    let date: String?
    let time: String?
    let type: String?
    let userName: String?
    let status: ProviderOrderStatus?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNum = "order_num"
        case image, date, time, type, status
        case userName = "user_name"
    }
}

struct ProviderOrderStatus: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?

    enum CodingKeys: String, CodingKey {
        case key, name, title
        case detailsText = "details_text"
    }
}

extension ProviderOrder {
    init(from clientOrder: ClientOrder) {
        self.id = clientOrder.id
        self.orderNum = clientOrder.orderNum
        self.image = clientOrder.logo
        self.date = clientOrder.date
        self.time = clientOrder.time
        self.type = clientOrder.productsType
        self.userName = clientOrder.userName
        self.status = ProviderOrderStatus(
            key: clientOrder.status?.key,
            name: clientOrder.status?.name,
            title: clientOrder.status?.title,
            detailsText: clientOrder.status?.detailsText
        )
    }
}

enum ProviderOrderType {
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
}

struct ProviderOrdersCount : Codable {
    let receiveNewOrders: Int?
    let returnNewOrders: Int?
    let totalNewOrders: Int?
    
    enum CodingKeys: String, CodingKey {
        case receiveNewOrders = "receive_new_orders"
        case returnNewOrders = "return_new_orders"
        case totalNewOrders = "total_new_orders"
    }
}
