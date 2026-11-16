//
//  ClientOrdersEndPoints.swift
//  GasmanProvider
//

import Foundation
import Alamofire

struct ClientOrdersEndPoints {
    private init() {}
}

extension ClientOrdersEndPoints {

    static func getOrders(path: String, page: Int) -> Endpoint<BaseResponse<ClientOrdersResponse>> {
        return .init(
            method: .get,
            path: "delegate/user-orders/\(path)",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func getOrderDetails(orderId : Int) -> Endpoint<BaseResponse<OrderDetails>>{
        return .init(
            method: .get,
            path: "delegate/user-orders/details/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func acceptOrder(id: Int) -> Endpoint<BaseResponse<OrderDetails>> {
        return .init(
            method: .post,
            path: "delegate/user-orders/accept/\(id)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func rejectOrder(id: Int) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/user-orders/refuse/\(id)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func onMyWay(orderId: Int) -> Endpoint<BaseResponse<OrderDetails>> {
        return .init(
            method: .post,
            path: "delegate/user-orders/on-way/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func deliverToCustomer(orderId: Int) -> Endpoint<BaseResponse<OrderDetails>> {
        return .init(
            method: .post,
            path: "delegate/user-orders/finish/\(orderId)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func rateClient(model: RateClientModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/user-orders/rate-user",
            body: [
                "order_id": model.orderId,
                "user_rate": model.userRate,
                "user_comment": model.userComment
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func delegateOrderCount() -> Endpoint<BaseResponse<DelegateOrderCount>> {
        return .init(
            method: .get,
            path: "delegate/user-orders/count-new",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
