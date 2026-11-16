//
//  LoginVM.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import Foundation
import Combine

final class LoginVM: BaseViewModel {

    @Published var login: BaseResponse<User>?
    @Published var validationError: Error?

    private let userType: UserType = Session.userType ?? .delegate_

    func loginRequest(model: LoginModel){
        isLoading = true
        if userType == .serviceProvider {
            providerLoginRequest(model: model)
        } else {
            delegateLoginRequest(model: model)
        }
    }

    private func delegateLoginRequest(model: LoginModel) {
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.login(model: model))
                Session.user = result.data
                Session.token = result.data?.token
                saveCredentials(model: model)
                isLoading = false
                login = result

            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func providerLoginRequest(model: LoginModel) {
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.providerLogin(model: model))
                Session.provider = result.data
                Session.token = result.data?.token
                saveCredentials(model: model)
                isLoading = false
                login = BaseResponse<User>(key: result.key, message: result.message, data: nil)

            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func saveCredentials(model: LoginModel) {
        if let phone = model.phone, let password = model.password {
            KeychainHelper.saveCredentials(phone: phone, password: password)
        }
    }

    func validateInputs(model: LoginModel) {

        do {
            _ = try ValidationService.validate(phone: model.phone)
            _ = try ValidationService.validate(password: model.password)
            loginRequest(model: model)

        }catch{
            validationError = error
        }
    }
}
