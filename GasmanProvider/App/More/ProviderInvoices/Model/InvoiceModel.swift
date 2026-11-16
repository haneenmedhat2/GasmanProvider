//
//  InvoiceModel.swift
//  GasmanProvider
//

import Foundation

struct InvoiceListResponse: Decodable {
    let pagination: Pagination?
    let data: [InvoiceItem]?
}

struct InvoiceItem: Decodable {
    let id: Int?
    let orderNum: String?
    let total: String?
    let currency: String?
    let date: String?
    let invoiceURL: String?
    let logo: String?

    enum CodingKeys: String, CodingKey {
        case id, total, currency, date, logo
        case orderNum = "order_num"
        case invoiceURL = "invoice_url"
    }
}

enum InvoiceTab {
    case customer, commission
}

// MARK: - Invoice Details -

struct InvoiceDetails: Decodable {
    let id: Int?
    let orderNum: String?
    let date: String?
    let time: String?
    let invoiceURL: String?
    let user: InvoiceUser?
    let items: [OrderItem]?
    let financials: Financials?

    enum CodingKeys: String, CodingKey {
        case id, date, time, user, items, financials
        case orderNum = "order_num"
        case invoiceURL = "invoice_url"
    }
}

struct InvoiceUser: Decodable {
    let name: String?
    let phone: String?
    let image : String?
}
