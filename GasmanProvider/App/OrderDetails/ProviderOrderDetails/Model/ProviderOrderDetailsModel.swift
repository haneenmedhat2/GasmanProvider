//
//  ProviderOrderDetailsModel.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import Foundation

struct ProviderOrderDetailsResponse: Codable {
    let id: Int?
    let orderNum: String?
    let date: String?
    let time: String?
    let status: StatusModel?
    let type: StatusModel?
    
    let totalMetalCylinders: Int?
    let totalFiberCylinders: Int?
    let emptyMetalCylinders: Int?
    let emptyFiberCylinders: Int?
    let fullMetalCylinders: Int?
    let fullFiberCylinders: Int?
    
    let delegate: DelegateInfo?
    let actions: ProviderOrderActions?
    let canceledReason: String?

    enum CodingKeys: String, CodingKey {
        case id, date, time, status, type, delegate, actions
        case orderNum = "order_num"
        case canceledReason = "canceled_reason"
        case totalMetalCylinders = "total_metal_cylinders"
        case totalFiberCylinders = "total_fiber_cylinders"
        case emptyMetalCylinders = "empty_metal_cylinders_count"
        case emptyFiberCylinders = "empty_fiber_cylinders_count"
        case fullMetalCylinders = "full_metal_cylinders_count"
        case fullFiberCylinders = "full_fiber_cylinders_count"
    }
}

extension ProviderOrderDetailsResponse {
    func getDataSource() -> [KeyValueModel] {
        var data: [KeyValueModel] = [
            KeyValueModel(title: "order_status".localized, value: status?.title),
            KeyValueModel(title: "order_type".localized, value: type?.title.map { String(format: "order_type_value_format".localized, $0) })
        ]
        
        if Session.userType == .delegate_ {
            if type?.name == "receive" {
                data.append(contentsOf: [
                    KeyValueModel(title: "metal_gas_cylinder".localized, value: "\(totalMetalCylinders ?? 0)"),
                    KeyValueModel(title: "fiber_gas_cylinder".localized, value: "\(totalFiberCylinders ?? 0)")
                ])
            } else if type?.name == "return" {
                data.append(contentsOf: [
                    KeyValueModel(title: "full_metal_cylinder".localized, value: "\(fullMetalCylinders ?? 0)"),
                    KeyValueModel(title: "empty_metal_cylinder".localized, value: "\(emptyMetalCylinders ?? 0)"),
                    KeyValueModel(title: "full_fiber_cylinder".localized, value: "\(fullFiberCylinders ?? 0)"),
                    KeyValueModel(title: "empty_fiber_cylinder".localized, value: "\(emptyFiberCylinders ?? 0)")
                ])
            }
        } else {
            data.append(contentsOf: [
                KeyValueModel(title: "metal_gas_cylinder".localized, value: "\(totalMetalCylinders ?? 0)"),
                KeyValueModel(title: "fiber_gas_cylinder".localized, value: "\(totalFiberCylinders ?? 0)")
            ])
        }
        return data
    }
}

struct DelegateInfo: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let fullPhone: String?
    let lat: Double?
    let lng: Double?
    let mapDesc: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, lat, lng
        case fullPhone = "full_phone"
        case mapDesc = "map_desc"
    }
}

struct ProviderOrderActions: Codable {
    let acceptButton: Bool?
    let refuseButton: Bool?
    let finishedButton: Bool?
    
    enum CodingKeys: String, CodingKey {
        case acceptButton = "accept_button"
        case refuseButton = "refuse_button"
        case finishedButton = "finished_button"
    }
}
