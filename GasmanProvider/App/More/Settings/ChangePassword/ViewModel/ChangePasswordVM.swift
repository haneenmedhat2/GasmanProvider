//
//  ChangePasswordVM.swift
//  Esterad
//
//  Created by Haneen on 04/11/2025.
//

import Foundation
import Combine

final class ChangePasswordVM: BaseViewModel {
    
    @Published var changePassword: BaseResponse<String>?
    @Published var validation: Error?
    
    func changePasswordRequest(model :ChangePasswordModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.changePassword(model:model))
                isLoading = false
                changePassword = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData(model :ChangePasswordModel)  {
        do {
            let _ = try ValidationService.validate(oldPassword : model.currentPassword)
            let _ = try ValidationService.validate(newPassword: model.password)
            let _ = try ValidationService.validate(newPassword: model.password, confirmPassword: model.passwordConfirmation)
            changePasswordRequest(model :model)
        } catch {
            validation = error
        }
    }
}
