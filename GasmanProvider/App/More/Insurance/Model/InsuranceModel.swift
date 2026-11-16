//
//  InsuranceModel.swift
//  GasmanProvider
//

import Foundation

struct InsuranceResponse: Codable {
    let balance: String?
    let availableBalance: String?
    let pendingBalance: String?
    let possibleAndActualCylinders: PossibleAndActualCylinders?

    enum CodingKeys: String, CodingKey {
        case balance
        case availableBalance = "available_balance"
        case pendingBalance = "pending_balance"
        case possibleAndActualCylinders = "possible_and_actual_cylinders"
    }
}

struct PossibleAndActualCylinders: Codable {
    let metalCylinders: CylinderInfo?
    let fiberCylinders: CylinderInfo?

    enum CodingKeys: String, CodingKey {
        case metalCylinders = "metal_cylinders"
        case fiberCylinders = "fiber_cylinders"
    }
}

struct CylinderInfo: Codable {
    let possibleQty: Int?
    let actualQty: Int?
    let insurancePrice: String?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case possibleQty = "possible_qty"
        case actualQty = "actual_qty"
        case insurancePrice = "insurance_price"
        case currency
    }
}
