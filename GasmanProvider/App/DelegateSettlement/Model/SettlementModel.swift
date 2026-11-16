//
//  SettlementModel.swift
//  GasmanProvider
//

import Foundation

struct SettlementCashResponse: Codable {
    let totalCashReceived: String?
    let totalDeliveryFee: String?
    let totalOwedToProvider: String?
    let ordersCount: Int?
    let settleButton : Bool?

    enum CodingKeys: String, CodingKey {
        case totalCashReceived = "total_cash_received"
        case totalDeliveryFee = "total_delivery_fee"
        case totalOwedToProvider = "total_owed_to_provider"
        case ordersCount = "orders_count"
        case settleButton = "settle_button"
    }
}
