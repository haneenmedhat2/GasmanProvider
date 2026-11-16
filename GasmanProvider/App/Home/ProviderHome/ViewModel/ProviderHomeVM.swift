//
//  ProviderHomeVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class ProviderHomeVM: BaseViewModel {

    @Published var delegates: [DelegateRequestItem] = []
    @Published var tutorialVideo: TutorialVideoModel?
    @Published var notificationCount: Int? = 0
    @Published var newOrdersCount: Int? = 0

    private var currentPage = 1
    private(set) var isLastPage = false

    func resetAndFetch() {
        currentPage = 1
        isLastPage = false
        delegates.removeAll()
        fetchNextPage()
    }

    func fetchNextPage() {
        guard !isLoading, !isLastPage else { return }
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.providerDelegates(page: currentPage))
                let newItems = result.data?.data ?? []
                if currentPage == 1 {
                    delegates = newItems
                } else {
                    delegates.append(contentsOf: newItems)
                }
                isLastPage = result.data?.pagination?.isLastPage ?? true
                if !isLastPage { currentPage += 1 }
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func fetchTutorialVideo() {
        Task {
            do {
                let result = try await request(MoreEndpoints.tutorialVideo())
                tutorialVideo = result
            } catch {
                self.error = error
            }
        }
    }

    func markTutorialSeen() {
        Task {
            do {
                _ = try await getAllRequest(MoreEndpoints.seenTutorialVideo())
            } catch {
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
