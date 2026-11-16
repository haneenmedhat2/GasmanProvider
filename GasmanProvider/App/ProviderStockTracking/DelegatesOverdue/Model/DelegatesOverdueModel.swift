//
//  DelegatesOverdueModel.swift
//  GasmanProvider
//

import Foundation

struct DelegatesOverdueResponse: Decodable {
    let pagination: Pagination
    let delegates: [DelegateOverdue]
}

struct DelegateOverdue: Decodable {
    let id: Int?
    let name: String?
    let phone: String?
    let image: String?
    let overdueCylindersCount: Int?
    let msg: String?

    enum CodingKeys: String, CodingKey {
        case id, name, phone, image
        case overdueCylindersCount = "overdue_cylinders_count"
        case msg
    }
}
