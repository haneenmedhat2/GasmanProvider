//
//  HomeVM.swift
//  Esterad
//
//  Created by Haneen on 11/11/2025.
//

import Foundation
import Combine

final class HomeVM: BaseViewModel {

    @Published var home: BaseResponse<HomeResponse>?
    @Published private(set) var acceptSuccess: BaseResponse<OrderDetails>?
    @Published private(set) var refuseSuccess: BaseResponse<String>?
    @Published var receiveOrder: BaseResponse<Bool>?
    @Published var tutorialVideo: TutorialVideoModel?
    @Published var notificationCount: Int? = 0
    @Published var newOrdersCount: Int? = 0


    var ordersList: [ClientOrder] = []
    var currentPage: Int = 1
    var isLastPage: Bool = false

    func getHomeData() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(HomeEndPoints.getDelegateHome(page: currentPage))
                let newOrders = result.data?.orders ?? []
                if currentPage == 1 {
                    ordersList.removeAll()
                    ordersList = newOrders
                } else {
                    ordersList.append(contentsOf: newOrders)
                }
                isLastPage = result.data?.pagination?.isLastPage ?? true
                if !isLastPage {
                    currentPage += 1
                }
                home = result
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

    func switchReceiveOrders() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.switchReceivingOrders())
                receiveOrder = result
                profileRequest()
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
                profileRequest()
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
    
    func profileRequest() {
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.profile())
                guard let user = result.data else { return }
                Session.user = user
                isLoading = false
                
            } catch {
                self.error = error
            }
        }
    }
}
