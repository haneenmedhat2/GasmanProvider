//
//  StockTrackingSummaryModel.swift
//  GasmanProvider
//

import Foundation

struct StockTrackingSummaryModel: Decodable {
    let overdueCylindersCount: Int?
    let overdueSteelCylinders: CylinderStockInfo?
    let overdueFiberCylinders: CylinderStockInfo?
    let cylinder: String?
    let msg: String?

    enum CodingKeys: String, CodingKey {
        case overdueCylindersCount = "overdue_cylinders_count"
        case overdueSteelCylinders = "overdue_steel_cylinders"
        case overdueFiberCylinders = "overdue_fiber_cylinders"
        case cylinder, msg
    }

    var cylindersList: [CylinderStockInfo] {
        [overdueSteelCylinders, overdueFiberCylinders].compactMap { $0 }
    }
}

struct CylinderStockInfo: Decodable {
    let value: Int?
    let label: String?
    let image: String?
}
