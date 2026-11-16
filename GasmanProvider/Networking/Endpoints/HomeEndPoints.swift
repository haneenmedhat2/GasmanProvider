//
//  HomeEndPoints.swift
//  Esterad
//
//  Created by Haneen on 08/09/2025.
//

import Foundation
import Alamofire

struct HomeEndPoints {
    private init() {}
}

extension HomeEndPoints {
    
    static func getDelegateHome(page: Int) -> Endpoint<BaseResponse<HomeResponse>> {
        return .init(
            method: .get,
            path: "delegate/home",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func getProviderHome(page: Int) -> Endpoint<BaseResponse<HomeResponse>> {
        return .init(
            method: .get,
            path: "provider/home",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
}
