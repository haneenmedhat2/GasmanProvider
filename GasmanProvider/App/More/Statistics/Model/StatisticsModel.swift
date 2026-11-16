//
//  StatisticsModel.swift
//  GasmanProvider
//

import Foundation

// MARK: - General Statistics -

struct GeneralStatisticsData: Codable {
    let cylindersNotReturned: StatEntry?
    let deliveryOrdersCount: StatEntry?
    let repeatOrdersCount: StatEntry?
    let totalMetalCylindersReplaced: StatEntry?
    let totalMetalCylindersSold: StatEntry?
    let totalFiberCylindersReplaced: StatEntry?
    let totalFiberCylindersSold: StatEntry?
    let finishedOrders: StatEntry?
    let cancelledOrders: StatEntry?
    let refusedOrders: StatEntry?

    enum CodingKeys: String, CodingKey {
        case cylindersNotReturned = "cylinders_not_returned"
        case deliveryOrdersCount = "delivery_orders_count"
        case repeatOrdersCount = "repeat_orders_count"
        case totalMetalCylindersReplaced = "total_metal_cylinders_replaced"
        case totalMetalCylindersSold = "total_metal_cylinders_sold"
        case totalFiberCylindersReplaced = "total_fiber_cylinders_replaced"
        case totalFiberCylindersSold = "total_fiber_cylinders_sold"
        case finishedOrders = "finished_orders"
        case cancelledOrders = "cancelled_orders"
        case refusedOrders = "refused_orders"
    }

    var gridItems: [StatEntry] {
        [deliveryOrdersCount, repeatOrdersCount,
         totalMetalCylindersReplaced,totalMetalCylindersSold,
         totalFiberCylindersReplaced, totalFiberCylindersSold, cancelledOrders , refusedOrders].compactMap { $0 }
    }
}

struct StatEntry: Codable {
    let value: Int?
    let label: String?
    let icon: String?
}

enum StatisticsPeriod: String, CaseIterable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case yearly = "yearly"
}

// MARK: - Profit Statistics -

struct ProfitStatisticsItem: Codable {
    let key: String?
    let value: String?
    let currency: String?
    let label: String?
    let icon: String?
    let color: String?
}

enum StatisticsTab {
    case general, profits
}
