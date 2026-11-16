//
//  Provider.swift
//  GasmanProvider
//

import Foundation

struct Provider: Codable {
    let id: Int?
    let name: String?
    let countryCode: String?
    let phone: String?
    let fullPhone: String?
    let image: String?
    let lang: String?
    let isNotify: Bool?
    let isCompleted: Bool?
    let rateAvg: String?
    let rateCount: Int?
    let canOrder: Bool?
    let commercialNumber: String?
    let token: String?
    let city: LookupModel?
    let neighborhoods: [LookupModel]?
    let storeName: String?
    let lat: Double?
    let lng: Double?
    let mapDesc: String?
    let bankInfo: BankInfo?
    let commercialImage: String?
    let commercialEndDate: String?
    let permissionImage: String?
    let permissionEndDate: String?
    let identityImage: String?
    let providerSource: DelegateType?
    let isSeenTutorialVideo: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, image, token, lang, lat, lng
        case city, neighborhoods
        case countryCode = "country_code"
        case fullPhone = "full_phone"
        case isNotify = "is_notify"
        case isCompleted = "is_completed"
        case rateAvg = "rate_avg"
        case rateCount = "rate_count"
        case canOrder = "can_order"
        case commercialNumber = "commercial_number"
        case storeName = "store_name"
        case mapDesc = "map_desc"
        case bankInfo = "bank_info"
        case commercialImage = "commercial_image"
        case commercialEndDate = "commercial_end_date"
        case permissionImage = "permission_image"
        case permissionEndDate = "permission_end_date"
        case identityImage = "identity_image"
        case providerSource = "provider_source"
        case isSeenTutorialVideo = "is_seen_tutorial_video"
    }
}
