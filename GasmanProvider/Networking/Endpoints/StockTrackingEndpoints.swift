//
//  StockTrackingEndpoints.swift
//  GasmanProvider
//

import Foundation
import Alamofire

struct StockTrackingEndpoints {
    private init() {}
}

extension StockTrackingEndpoints {

    static func summary() -> Endpoint<BaseResponse<StockTrackingSummaryModel>> {
        return .init(
            method: .get,
            path: "provider/stock-tracking/summary",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func delegatesOverdue(page: Int) -> Endpoint<BaseResponse<DelegatesOverdueResponse>> {
        return .init(
            method: .get,
            path: "provider/stock-tracking/delegates-overdue",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
