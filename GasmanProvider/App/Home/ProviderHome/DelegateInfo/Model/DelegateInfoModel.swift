//
//  DelegateInfoModel.swift
//  GasmanProvider
//

import Foundation

struct ToggleStorageData: Codable {
    let canAddStorage: Bool?

    enum CodingKeys: String, CodingKey {
        case canAddStorage = "can_add_storage"
    }
}

enum DelegateInfoTab: Int {
    case personal = 0
    case reports = 1
    case settlement = 2
}
