//
//  StockTrackingVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class StockTrackingVM: BaseViewModel {

    @Published var summary: StockTrackingSummaryModel?
    @Published var notificationCount: Int? = 0


    func fetchSummary() {
        isLoading = true
        Task {
            do {
                let result = try await request(StockTrackingEndpoints.summary())
                summary = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
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
}
