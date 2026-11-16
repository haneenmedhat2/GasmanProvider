//
//  DelegateRequestModel.swift
//  GasmanProvider
//

import Foundation

struct DelegateRequestsResponse: Decodable {
    let pagination: Pagination?
    let data: [DelegateRequestItem]?
}

struct DelegateRequestItem: Decodable {
    let id: Int?
    let name: String?
    let phone: String?
    let image: String?
    let type: DelegateType?
    let providerApprovalStatus: Bool?
    let canAddStorage: Bool?
    let canOrder: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, image, type
        case providerApprovalStatus = "provider_approval_status"
        case canAddStorage = "can_add_storage"
        case canOrder = "can_order"
    }
}
