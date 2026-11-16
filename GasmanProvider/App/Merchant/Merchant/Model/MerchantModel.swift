//
//  MerchantModel.swift
//  GasmanProvider
//

import Foundation

struct MerchantProvidersResponse: Decodable {
    let pagination: MerchantPagination?
    let providers: [MerchantProvider]?
}

struct MerchantProvider: Decodable {
    let id: Int?
    let name: String?
    let image: String?
    let mapDesc: String?
    let distance: String?
    let fullPhone: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image, distance
        case mapDesc   = "map_desc"
        case fullPhone = "full_phone"
    }
}

struct MerchantPagination: Decodable {
    let totalItems: Int?
    let countItems: Int?
    let perPage: Int?
    let totalPages: Int?
    let currentPage: Int?
    let nextPageUrl: String?
    let pervPageUrl: String?

    enum CodingKeys: String, CodingKey {
        case totalItems  = "total_items"
        case countItems  = "count_items"
        case perPage     = "per_page"
        case totalPages  = "total_pages"
        case currentPage = "current_page"
        case nextPageUrl = "next_page_url"
        case pervPageUrl = "perv_page_url"
    }
}
