//
//  VerificationVM.swift
//  Esterad
//
//  Created by Haneen on 19/10/2025.
//

import Foundation
import Combine

final class VerificationVM : BaseViewModel  {
    @Published var verification: String?
    @Published var resendCode: BaseResponse<String>?
    @Published var validation: Error?
    
    @Published private(set) var remainingTime: Int = 59
    @Published private(set) var isResendEnabled: Bool = false

    private var timer: Timer?
    private let baseTime = 59

    private var cancellables = Set<AnyCancellable>()
    
    var phone : String
    private let userType: UserType

    init(phone: String, userType: UserType = Session.userType ?? .delegate_) {
        self.phone = phone
        self.userType = userType
    }
    
    func startCountdown() {
        timer?.invalidate()
        isResendEnabled = false
        remainingTime = baseTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.remainingTime -= 1
            
            if self.remainingTime <= 0 {
                stopCountdown()
            }
        }
    }
    
    func stopCountdown() {
        timer?.invalidate()
        timer = nil
        isResendEnabled = true
    }
    
    func validateOTP(otp : String?)  {
        do {
            let validatedOTP = try  ValidationService.validate(verificationCode: otp)
            let model = VerificationModel(code: validatedOTP, countryCode: "966", phone: phone, deviceId: UserDefaults.pushNotificationToken ?? "", deviceType: "ios")
            verificationRequest(model : model)
        }catch {
            validation = error
        }
    }
    
    func verificationRequest(model: VerificationModel) {
        isLoading = true
        if userType == .serviceProvider {
            providerVerificationRequest(model: model)
        } else {
            delegateVerificationRequest(model: model)
        }
    }

    private func delegateVerificationRequest(model: VerificationModel) {
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.verification(model: model))
                Session.user = result.data
                Session.token = result.data?.token
                isLoading = false
                verification = result.message
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func providerVerificationRequest(model: VerificationModel) {
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.providerVerification(model: model))
                Session.provider = result.data
                Session.token = result.data?.token
                isLoading = false
                verification = result.message
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resendCodeRequest(){
        isLoading = true
        let endpoint: Endpoint<BaseResponse<String>> = userType == .serviceProvider
            ? AuthEndpoints.providerResendCode(phone: phone)
            : AuthEndpoints.resendCode(phone: phone)
        Task {
            do {
                let result = try await getAllRequest(endpoint)
                isLoading = false
                resendCode = result

            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}

