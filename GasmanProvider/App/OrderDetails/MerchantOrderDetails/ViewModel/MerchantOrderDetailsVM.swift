//
//  MerchantOrderDetailsVM.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import Foundation
import Combine

final class MerchantOrderDetailsVM: BaseViewModel {

    @Published private(set) var orderDetails: MerchantOrderDetailsResponse?
    @Published private(set) var cancelReasons: [CancelReasonModel] = []
    @Published private(set) var cancelSuccess: BaseResponse<String>?
    @Published private(set) var deliverToProviderSuccess: BaseResponse<MerchantOrderDetailsResponse>?
    @Published private(set) var finishSuccess: BaseResponse<MerchantOrderDetailsResponse>?

    let orderId: Int

    init(orderId: Int) {
        self.orderId = orderId
    }

    func getOrderDetails() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MerchantOrdersEndPoints.getOrderDetails(orderId: orderId))
                orderDetails = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getCancelReasons() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MerchantOrdersEndPoints.getCancelReasons())
                cancelReasons = result.data ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func deliverToProvider() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MerchantOrdersEndPoints.deliverToProvider(orderId: orderId))
                deliverToProviderSuccess = result
                getOrderDetails()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func finishOrder() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MerchantOrdersEndPoints.finishOrder(orderId: orderId))
                finishSuccess = result
                getOrderDetails()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func cancelOrder(reasonId: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MerchantOrdersEndPoints.cancelOrder(orderId: orderId, cancelReasonId: reasonId))
                cancelSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
