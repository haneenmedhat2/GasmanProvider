//
//  StorageModel.swift
//  GasmanProvider
//

import Foundation

struct StorageResponse: Decodable {
    let canAddStorage: Bool?
    let storage: [StorageCategoryModel]?

    enum CodingKeys: String, CodingKey {
        case canAddStorage = "can_add_storage"
        case storage
    }
}

struct StorageCategoryModel: Decodable {
    let categoryId: Int?
    let categoryName: String?
    let total: StorageEntry?
    let filled: StorageEntry?
    let empty: StorageEntry?

    enum CodingKeys: String, CodingKey {
        case categoryId   = "category_id"
        case categoryName = "category_name"
        case total, filled, empty
    }

    var rows: [StorageEntry] {
        [total, filled, empty].compactMap { $0 }
    }
}

struct StorageEntry: Decodable {
    let qty: Int?
    let name: String?
}

struct StorageUpdateResponse: Decodable {
    let fiberFullQty: Int?
    let steelFullQty: Int?

    enum CodingKeys: String, CodingKey {
        case fiberFullQty = "fiber_full_qty"
        case steelFullQty = "steel_full_qty"
    }
}
