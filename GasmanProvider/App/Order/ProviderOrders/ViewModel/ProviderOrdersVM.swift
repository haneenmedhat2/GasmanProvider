//
//  ProviderOrdersVM.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import Foundation
import Combine

final class ProviderOrdersVM: BaseViewModel {

    @Published var orders: BaseResponse<ProviderOrdersResponse>?
    @Published var notificationCount: Int? = 0
    @Published var newOrdersCount: Int? = 0
    
    var currentPage: Int = 1
    var isLastPage: Bool = false
    
    var ordersList: [ProviderOrder] = []
    var orderType: ProviderOrderType = .receive
    
    var status: OrderStatus = .new
    let statusList: [OrderStatus] = [.new, .current, .finished]

    func getOrders() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    ProviderOrdersEndPoints.getOrders(
                        type: orderType.apiValue,
                        status: status.apiValue,
                        page: currentPage
                    )
                )
                let newOrders = result.data?.orders ?? []
                if currentPage == 1 {
                    ordersList.removeAll()
                    ordersList = newOrders
                } else {
                    ordersList.append(contentsOf: newOrders)
                }
                isLastPage = result.data?.pagination?.isLastPage ?? false
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
    
    
    func getNotificationCount() {
        isLoading = true
        
        Task {
            do {
                let result = try await getAllRequest(
                    NotificationsEndPoints.notificationCount()
                )
                
                notificationCount = result.data?.count ?? 0
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func getOrdersCount() {
        isLoading = true
        
        Task {
            do {
                let result = try await getAllRequest(
                    ProviderOrdersEndPoints.providerOrderCount()
                )
                
                newOrdersCount = result.data?.totalNewOrders ?? 0
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
