//
//  ClientOrderDetailsVM.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

import Foundation
import Combine

final class ClientOrderDetailsVM: BaseViewModel {

    @Published private(set) var orderDetails: OrderDetails?
    @Published private(set) var acceptSuccess: BaseResponse<OrderDetails>?
    @Published private(set) var refuseSuccess: BaseResponse<String>?
    @Published private(set) var onMyWaySuccess: BaseResponse<OrderDetails>?
    @Published private(set) var deliverSuccess: BaseResponse<OrderDetails>?
    @Published private(set) var rateClientSuccess: BaseResponse<String>?
    private(set) var lastRateModel: RateOrderModel?

    let orderId: Int

    init(orderId: Int) {
        self.orderId = orderId
    }

    func getOrderDetails() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ClientOrdersEndPoints.getOrderDetails(orderId: orderId))
                orderDetails = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func acceptOrder() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ClientOrdersEndPoints.acceptOrder(id: orderId))
                acceptSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func refuseOrder() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ClientOrdersEndPoints.rejectOrder(id: orderId))
                refuseSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func onMyWay() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ClientOrdersEndPoints.onMyWay(orderId: orderId))
                onMyWaySuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func deliverToCustomer() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ClientOrdersEndPoints.deliverToCustomer(orderId: orderId))
                deliverSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func rateClient(model: RateClientModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ClientOrdersEndPoints.rateClient(model: model))
                rateClientSuccess = result
                getOrderDetails()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
