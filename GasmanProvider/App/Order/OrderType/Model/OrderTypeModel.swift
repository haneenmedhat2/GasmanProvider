//
//  OrderTypeModel.swift
//  GasmanProvider
//
//  Created by Haneen on 24/03/2026.
//

import Foundation

struct OrderTypeModel {
    let id : Int
    let name : String
}

extension OrderTypeModel {
    static func getOrderTypeList() -> [OrderTypeModel]{
        return [
            OrderTypeModel(id: 1, name: "client_orders".localized),
            OrderTypeModel(id: 2, name: "merchant_orders".localized)
        ]
    }
}

struct DelegateOrderCount : Codable {
    let count : Int?
}
