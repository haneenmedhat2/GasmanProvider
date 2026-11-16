//
//  SettingsVMProtocol.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import Foundation
import Combine

final class SettingsVM: BaseViewModel {
    
    @Published var switchNotification: BaseResponse<SwitchNotification>?
    @Published var deleteAccount: BaseResponse<String>?
    
    var switchNotificationPublisher: Published<BaseResponse<SwitchNotification>?>.Publisher { $switchNotification }
    var deleteAccountPublisher: Published<BaseResponse<String>?>.Publisher { $deleteAccount }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    var settingsItems : [MoreMenuItem] {
        return MoreMenuItem.settingsItems()
    }

    func changeLanguage(lang: String){
        isLoading = true
        Task {
            do {
                _ = try await getAllRequest(MoreEndpoints.changeLanguage( lang: lang))
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
        
    func switchNotificationRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.switchNotification())
                isLoading = false
                switchNotification = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func deleteAccountRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.deleteAccount( deviceId: UserDefaults.pushNotificationToken ?? "" ))
                isLoading = false
                deleteAccount = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}

