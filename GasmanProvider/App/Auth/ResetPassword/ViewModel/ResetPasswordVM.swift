//
//  ResetPasswordVM.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation
import Combine

final class ResetPasswordVM : BaseViewModel  {
    @Published var resetPassword: BaseResponse<String>?
    @Published var validation: Error?
    
    var phone : String
    var code : String
    private let userType: UserType

    init(phone: String, code: String, userType: UserType = Session.userType ?? .delegate_) {
        self.phone = phone
        self.code = code
        self.userType = userType
    }

    func resetPassword(model: ResetPasswordModel) {
        isLoading = true
        let endpoint: Endpoint<BaseResponse<String>> = userType == .serviceProvider
            ? AuthEndpoints.providerResetPassword(model: model)
            : AuthEndpoints.resetPassword(model: model)
        Task {
            do {
                let result = try await getAllRequest(endpoint)
                isLoading = false
                resetPassword = result

            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateUserData( password : String? , confirmPassword : String?){
        do {
            let password = try ValidationService.validate(password: password)
            let confirmPassword = try ValidationService.validate(newPassword: password, confirmPassword: confirmPassword)
            let model = ResetPasswordModel(phone: phone, password: password, passwordConfirmation: confirmPassword, code: code)
            resetPassword(model: model)
            
        }catch{
            validation = error
        }
    }
}

