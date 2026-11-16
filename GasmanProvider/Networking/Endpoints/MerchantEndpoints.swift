//
//  MerchantEndpoints.swift
//  GasmanProvider
//

import Foundation
import Alamofire

struct MerchantEndpoints {
    private init() {}
}

extension MerchantEndpoints {
    
    static func providerProfile() -> Endpoint<BaseResponse<MerchantProvider>> {
        return .init(
            method: .get,
            path: "delegate/provider/profile",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func allProviders() -> Endpoint<BaseResponse<MerchantProvidersResponse>> {
        return .init(
            method: .get,
            path: "delegate/provider/all",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func changeProvider(id: Int) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/provider/change",
            body: ["provider_id": id],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func createProviderOrder(type: Int, products: [[String: Any]]) -> Endpoint<BaseResponse<Int>> {
        
        return .init(
            method: .post,
            path: "delegate/provider-orders/create",
            body: [
                "type": type,
                "products": products
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
