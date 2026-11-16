//
//  OrderTypeVM.swift
//  GasmanProvider
//
//  Created by Haneen on 24/03/2026.
//

import Foundation
import Combine


final class OrderTypeVM: BaseViewModel {
    
    @Published var notificationCount: Int? = 0
    @Published var newOrdersCount: Int? = 0
    
    var orderTypeList : [OrderTypeModel] = OrderTypeModel.getOrderTypeList()
    
    
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
                    ClientOrdersEndPoints.delegateOrderCount()
                )
                
                newOrdersCount = result.data?.count ?? 0
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
