//
//  MoreViewModel.swift
//  Esterad
//
//  Created by Haneen on 29/10/2025.
//

import Foundation
import Combine

final class MoreVM: BaseViewModel {

    @Published var receiveOrder: BaseResponse<Bool>?
    @Published var notificationCount: Int? = 0

    var signout: PassthroughSubject<BaseResponse<String>, Never> = .init()

    var menuItems: [MoreMenuItem] {
        return MoreMenuItem.moreItems()
    }

    var moreList : [MoreMenuItem] = []

    func signoutRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.signout( deviceId:  UserDefaults.pushNotificationToken ?? "" ))
                signout.send(result)
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
