//
//  CreateMerchantOrderVM.swift
//  GasmanProvider
//

import Foundation
import Combine
import UIKit

final class CreateMerchantOrderVM: BaseViewModel {

    @Published var orderType: MerchantOrderType = .receive
    @Published var orderCreated: BaseResponse<Int>?

    // Receive counts
    var metalQty: Int = 0
    var fiberQty: Int = 0

    // Return counts
    var emptyMetalQty: Int = 0
    var emptyFiberQty: Int = 0
    var fullMetalQty: Int = 0
    var fullFiberQty: Int = 0
    
    let orderTypes: [SelectionOptionType] = [.receiveOrder, .returnOrder]
    var selectedIndex = IndexPath(item: 0, section: 0)

    func resetCounts() {
        metalQty = 0
        fiberQty = 0
        emptyMetalQty = 0
        emptyFiberQty = 0
        fullMetalQty = 0
        fullFiberQty = 0
    }

    func createOrder() {
        var products: [[String: Any]] = []

        switch orderType {
        case .receive:
            if metalQty > 0 {
                products.append(["product_id": 1, "qty": metalQty, "product_type": 0])
            }
            if fiberQty > 0 {
                products.append(["product_id": 3, "qty": fiberQty, "product_type": 0])
            }
        case .return:
            if emptyMetalQty > 0 {
                products.append(["product_id": 1, "qty": emptyMetalQty, "product_type": 1])
            }
            if emptyFiberQty > 0 {
                products.append(["product_id": 3, "qty": emptyFiberQty, "product_type": 1])
            }
            if fullMetalQty > 0 {
                products.append(["product_id": 1, "qty": fullMetalQty, "product_type": 0])
            }
            if fullFiberQty > 0 {
                products.append(["product_id": 3, "qty": fullFiberQty, "product_type": 0])
            }
        }

        guard !products.isEmpty else { return }

        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MerchantEndpoints.createProviderOrder(type: orderType.createOrderValue, products: products)
                )
                orderCreated = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
