//
//  MerchantOrderDetailsModel.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import Foundation

struct MerchantOrderDetailsResponse: Codable {
    let id: Int?
    let orderNum: String?
    let date: String?
    let time: String?
    let type: StatusModel?
    let status: StatusModel?
    
    let totalMetalCylinders: Int?
    let totalFiberCylinders: Int?
    
    let emptyMetalCylinders: Int?
    let emptyFiberCylinders: Int?
    let fullMetalCylinders: Int?
    let fullFiberCylinders: Int?
    
    let provider: ProviderInfo?
    let actions: MerchantOrderActions?
    let canceledReason: String?

    enum CodingKeys: String, CodingKey {
        case id
        case orderNum = "order_num"
        case date, time, type, status, provider, actions
        case canceledReason = "cancelled_reason"

        case totalMetalCylinders = "total_metal_cylinders"
        case totalFiberCylinders = "total_fiber_cylinders"
        
        case emptyMetalCylinders = "empty_metal_cylinders_count"
        case emptyFiberCylinders = "empty_fiber_cylinders_count"
        case fullMetalCylinders = "full_metal_cylinders_count"
        case fullFiberCylinders = "full_fiber_cylinders_count"
    }
}

extension MerchantOrderDetailsResponse {
    func getDataSource() -> [KeyValueModel] {
        
        var data: [KeyValueModel] = [
            KeyValueModel(title: "order_status".localized, value: status?.title),
            KeyValueModel(title: "order_type".localized, value: type?.title.map { String(format: "order_type_value_format".localized, $0) })
        ]
        
        if type?.name == "receive" {
            data.append(contentsOf: [
                KeyValueModel(title: "metal_gas_cylinder".localized, value: "\(totalMetalCylinders ?? 0)"),
                
                KeyValueModel(title: "fiber_gas_cylinder".localized,value: "\(totalFiberCylinders ?? 0)")
            ])
        }
        
        else if type?.name == "return" {
            data.append(contentsOf: [
                KeyValueModel(title: "full_metal_cylinder".localized,value: "\(fullMetalCylinders ?? 0)"),
                
                KeyValueModel(title: "empty_metal_cylinder".localized, value: "\(emptyMetalCylinders ?? 0)"),
                
                KeyValueModel(title: "full_fiber_cylinder".localized, value: "\(fullFiberCylinders ?? 0)"),
                
                KeyValueModel(title: "empty_fiber_cylinder".localized,value: "\(emptyFiberCylinders ?? 0)")
            ])
        }
        
        return data
    }
}

struct ProviderInfo: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let phone: String?
    let lat: String?
    let lng: String?
    let mapDesc: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, phone, lat, lng
        case mapDesc = "map_desc"
    }
}

struct MerchantOrderActions: Codable {
    let cancelButton: Bool?
    let finishButton: Bool?
    let deliverToProviderButton: Bool?

    enum CodingKeys: String, CodingKey {
        case cancelButton = "cancel_button"
        case finishButton = "finish_button"
        case deliverToProviderButton = "deliver_to_provider_button"
    }
}
