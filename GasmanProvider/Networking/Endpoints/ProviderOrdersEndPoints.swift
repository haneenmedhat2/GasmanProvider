//
//  ProviderOrdersEndPoints.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import Foundation
import Alamofire

struct ProviderOrdersEndPoints {
    private init() {}
}

extension ProviderOrdersEndPoints {

    static func getOrders(type: String, status: String, page: Int) -> Endpoint<BaseResponse<ProviderOrdersResponse>> {
        return .init(
            method: .get,
            path: "provider/orders/\(type)/\(status)",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func getOrderDetails(orderId: Int) -> Endpoint<BaseResponse<ProviderOrderDetailsResponse>> {
        return .init(
            method: .get,
            path: "provider/orders/details/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func acceptOrder(orderId: Int) -> Endpoint<BaseResponse<ProviderOrderDetailsResponse>> {
        return .init(
            method: .post,
            path: "provider/orders/accept/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func getRefuseReasons() -> Endpoint<BaseResponse<[CancelReasonModel]>> {
        return .init(
            method: .get,
            path: "refuse-reasons",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func refuseOrder(orderId: Int, refuseReasonId: Int) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/orders/refuse",
            body: [
                "order_id": orderId,
                "refuse_reason_id": refuseReasonId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func finishOrder(orderId: Int) -> Endpoint<BaseResponse<ProviderOrderDetailsResponse>> {
        return .init(
            method: .post,
            path: "provider/orders/finish/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func providerOrderCount() -> Endpoint<BaseResponse<ProviderOrdersCount>> {
        return .init(
            method: .get,
            path: "provider/orders/counts",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
