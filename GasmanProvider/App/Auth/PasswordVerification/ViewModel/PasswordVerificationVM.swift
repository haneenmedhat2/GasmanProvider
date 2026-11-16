//
//  PasswordVerificationVM.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//


import Foundation
import Combine

protocol PasswordVerificationVMProtocol {
    var verificationPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { get }
    
    var remainingTimePublisher: Published<Int>.Publisher { get }
    var isResendEnabledPublisher: Published<Bool>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var phone : String { get }
    var otp : String { get set }

    func startCountdown()
    func validateOTP(otp : String?)
    func verificationRequest(phone: String , code : String)
    func resendCodeRequest()
}

final class PasswordVerificationVM : BaseViewModel , PasswordVerificationVMProtocol {
    @Published var verification: BaseResponse<String>?
    @Published var resendCode: BaseResponse<String>?
    @Published var validation: Error?
    
    @Published private(set) var remainingTime: Int = 59
    @Published private(set) var isResendEnabled: Bool = false
    
    var verificationPublisher: Published<BaseResponse<String>?>.Publisher { $verification }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { $resendCode }
    
    var remainingTimePublisher: Published<Int>.Publisher {$remainingTime}
    var isResendEnabledPublisher: Published<Bool>.Publisher { $isResendEnabled }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private var timer: Timer?
    private let baseTime = 59

    private var cancellables = Set<AnyCancellable>()
    
    var phone : String
    var otp : String = ""
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
            self.otp = validatedOTP
            verificationRequest(phone: phone, code: validatedOTP)
        }catch {
            validation = error
        }
    }
    
    func verificationRequest(phone: String , code : String) {
        isLoading = true
        let endpoint: Endpoint<BaseResponse<String>> = userType == .serviceProvider
            ? AuthEndpoints.providerForgetPasswordCheckCode(phone: phone, code: code)
            : AuthEndpoints.forgetPasswordCheckCode(phone: phone, code: code)
        Task {
            do {
                let result = try await getAllRequest(endpoint)
                isLoading = false
                verification = result

            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resendCodeRequest(){
        isLoading = true
        let endpoint: Endpoint<BaseResponse<String>> = userType == .serviceProvider
            ? AuthEndpoints.providerForgetPasswordResendCode(phone: phone)
            : AuthEndpoints.forgetPasswordResendCode(phone: phone)
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

