//
//  ProviderOrderDetailsVM.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import Foundation
import Combine

final class ProviderOrderDetailsVM: BaseViewModel {

    @Published private(set) var orderDetails: ProviderOrderDetailsResponse?
    @Published private(set) var refuseReasons: [CancelReasonModel] = []
    @Published private(set) var refuseSuccess: BaseResponse<String>?
    @Published private(set) var acceptSuccess: BaseResponse<ProviderOrderDetailsResponse>?
    @Published private(set) var finishSuccess: BaseResponse<ProviderOrderDetailsResponse>?

    let orderId: Int

    init(orderId: Int) {
        self.orderId = orderId
    }

    func getOrderDetails() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ProviderOrdersEndPoints.getOrderDetails(orderId: orderId))
                orderDetails = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getRefuseReasons() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(ProviderOrdersEndPoints.getRefuseReasons())
                refuseReasons = result.data ?? []
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
                let result = try await getAllRequest(ProviderOrdersEndPoints.acceptOrder(orderId: orderId))
                acceptSuccess = result
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
                let result = try await getAllRequest(ProviderOrdersEndPoints.finishOrder(orderId: orderId))
                finishSuccess = result
                getOrderDetails()
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func refuseOrder(reasonId: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    ProviderOrdersEndPoints.refuseOrder(orderId: orderId, refuseReasonId: reasonId)
                )
                refuseSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
