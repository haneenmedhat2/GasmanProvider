//
//  ClientOrdersVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class ClientOrdersVM: BaseViewModel {

    @Published var orders: BaseResponse<ClientOrdersResponse>?
    @Published private(set) var acceptSuccess: BaseResponse<OrderDetails>?
    @Published private(set) var refuseSuccess: BaseResponse<String>?

    var currentPage: Int = 1
    var isLastPage: Bool = false
    var ordersList: [ClientOrder] = []
    var status: OrderStatus = .new
    let statusList: [OrderStatus] = [.new, .current, .finished]

    var clientStatusList: [OrderStatus] {
        [.new, .current, .finished]
    }

    func getOrders() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    ClientOrdersEndPoints.getOrders(path: status.apiValue, page: currentPage)
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

    func acceptOrder(id: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    ClientOrdersEndPoints.acceptOrder(id: id)
                )
                acceptSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func rejectOrder(id: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    ClientOrdersEndPoints.rejectOrder(id: id)
                )
                refuseSuccess = result
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
