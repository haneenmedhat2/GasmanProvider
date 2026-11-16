//
//  MerchantOrdersVM.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import Foundation
import Combine

final class MerchantOrdersVM: BaseViewModel {

    @Published var orders: BaseResponse<MerchantOrdersResponse>?

    var currentPage: Int = 1
    var isLastPage: Bool = false
    var ordersList: [MerchantOrder] = []
    var orderType: MerchantOrderType = .receive
    var status: OrderStatus = .new
    let statusList: [OrderStatus] = [.new, .current, .finished]

    func getOrders() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MerchantOrdersEndPoints.getOrders(
                        type: orderType.apiValue,
                        status: status.apiValue,
                        page: currentPage
                    )
                )
                let newOrders = result.data?.data ?? []
                if currentPage == 1 {
                    ordersList.removeAll()
                    ordersList = newOrders
                } else {
                    ordersList.append(contentsOf: newOrders)
                }
                isLastPage = result.data?.pagination.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                orders = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resetData() {
        currentPage = 1
        isLastPage = false
    }
}
