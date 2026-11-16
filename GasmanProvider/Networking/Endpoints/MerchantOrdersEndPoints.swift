//
//  MerchantOrdersEndPoints.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import Foundation
import Alamofire

struct MerchantOrdersEndPoints {
    private init() {}
}

extension MerchantOrdersEndPoints {

    static func getOrders(type: String, status: String, page: Int) -> Endpoint<BaseResponse<MerchantOrdersResponse>> {
        return .init(
            method: .get,
            path: "delegate/provider-orders/\(type)/\(status)",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func getOrderDetails(orderId: Int) -> Endpoint<BaseResponse<MerchantOrderDetailsResponse>> {
        return .init(
            method: .get,
            path: "delegate/provider-orders/details/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func getCancelReasons() -> Endpoint<BaseResponse<[CancelReasonModel]>>{
        return .init(
            method: .get,
            path: "cancel-reasons",
            headerType: .authorized(token: Session.token ?? "")
        )
    }


    static func deliverToProvider(orderId: Int) -> Endpoint<BaseResponse<MerchantOrderDetailsResponse>> {
        return .init(
            method: .post,
            path: "delegate/provider-orders/deliver-to-provider/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func finishOrder(orderId: Int) -> Endpoint<BaseResponse<MerchantOrderDetailsResponse>> {
        return .init(
            method: .post,
            path: "delegate/provider-orders/finish/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func cancelOrder(orderId : Int,cancelReasonId: Int ) -> Endpoint<BaseResponse<String>>{
        return .init(
            method: .post,
            path: "delegate/provider-orders/cancel",
            body: [
                "order_id" : orderId,
                "cancel_reason_id" : cancelReasonId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
