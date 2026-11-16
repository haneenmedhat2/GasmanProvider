//
//  StorageVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class StorageVM: BaseViewModel {

    @Published var categories: [StorageCategoryModel] = []
    @Published var canAddStorage: Bool = false
    @Published var notificationCount: Int? = 0

    func fetchStorage() {
        isLoading = true
        Task {
            do {
                let result = try await request(MoreEndpoints.storage())
                categories = result?.storage ?? []
                canAddStorage = result?.canAddStorage ?? false
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
