//
//  NotificationVM.swift
//  Esterad
//
//  Created by Haneen on 09/12/2025.
//


import Foundation
import Combine

final class NotificationVM: BaseViewModel {
    
    @Published var notification: BaseResponse<NotificationResponse>?
    @Published var deleteNotification: BaseResponse<String>?
    @Published var deleteAllNotification: BaseResponse<String>?
    
    var notificationList : [NotificationModel] = []
    var currentPage:Int = 1
    var isLastPage: Bool = false
    var notificationId : String = ""
    private let userType: UserType = Session.userType ?? .delegate_


    func getNotification(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(NotificationsEndPoints.getNotifications(page: currentPage))
                
                let notificationList = result.data?.data ?? []
                
                if currentPage == 1 {
                    self.notificationList.removeAll()
                    self.notificationList = notificationList
                } else {
                    self.notificationList.append(contentsOf: notificationList)
                }
                
                isLastPage = result.data?.pagination?.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }
                
                isLoading = false
                notification = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteNotificationRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(NotificationsEndPoints.deleteNotification( notificationId: notificationId))
                getNotification()
                isLoading = false
                deleteNotification = result
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteAllNotifications(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(NotificationsEndPoints.deleteAllNotifications())
                getNotification()
                isLoading = false
                deleteAllNotification = result
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resetData(){
        currentPage = 1
        isLastPage = false
    }
}
