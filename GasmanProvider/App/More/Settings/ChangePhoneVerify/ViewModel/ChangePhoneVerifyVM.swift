//
//  ChangePhoneVerifyVM.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//


import Foundation
import Combine

protocol ChangePhoneVerifyVMProtocol {
    var oldPhoneCodePublisher: Published<BaseResponse<String>?>.Publisher { get }
    var verificationPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var newPhonePublisher: Published<BaseResponse<User>?>.Publisher { get }

    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { get }
    
    var remainingTimePublisher: Published<Int>.Publisher { get }
    var isResendEnabledPublisher: Published<Bool>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }
    
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var phone : String { get }
    var mode : ChangePhoneMode { get }
    
    func startCountdown()
    func validateOTP(otp : String?)
    func sendCurrentPhoneCode()
    func changeOldPhoneCheckCode(code : String)
    func resendCodeRequest()
    func newPhoneCheckCode(code : String , phone : String)
}

final class ChangePhoneVerifyVM : BaseViewModel , ChangePhoneVerifyVMProtocol {
    @Published var oldPhoneCode: BaseResponse<String>?
    @Published var verification: BaseResponse<String>?
    @Published var newPhone: BaseResponse<User>?

    @Published var resendCode: BaseResponse<String>?
    @Published var validation: Error?
    
    @Published private(set) var remainingTime: Int = 59
    @Published private(set) var isResendEnabled: Bool = false
    
    var oldPhoneCodePublisher: Published<BaseResponse<String>?>.Publisher { $oldPhoneCode }
    var verificationPublisher: Published<BaseResponse<String>?>.Publisher { $verification }
    var resendCodePublisher: Published<BaseResponse<String>?>.Publisher { $resendCode }
    var newPhonePublisher: Published<BaseResponse<User>?>.Publisher { $newPhone }

    var updateLocationPublisher: PassthroughSubject<BaseResponse<String>,Never> = .init()
    
    var remainingTimePublisher: Published<Int>.Publisher {$remainingTime}
    var isResendEnabledPublisher: Published<Bool>.Publisher { $isResendEnabled }
    var validationPublisher: Published<Error?>.Publisher { $validation }
    
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }
    
    private var timer: Timer?
    private let baseTime = 59

    private var cancellables = Set<AnyCancellable>()
    
    var phone : String
    var mode : ChangePhoneMode

    init(mode : ChangePhoneMode,phone : String){
        self.phone = phone
        self.mode = mode
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
            switch mode {
            case .oldPhone:
                changeOldPhoneCheckCode(code: validatedOTP)
            case .newPhone:
                newPhoneCheckCode(code: validatedOTP, phone: phone)
            }
           
        }catch {
            validation = error
        }
    }
    
    func sendCurrentPhoneCode(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.sendCurrentPhoneCode())
                isLoading = false
                oldPhoneCode  = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func changeOldPhoneCheckCode(code : String) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.changeOldPhoneCheckCode(code: code))
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
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.resendPhoneCode(type: mode.typeNum))
                isLoading = false
                resendCode = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func newPhoneCheckCode(code : String , phone : String){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.newPhoneCheckCode(code: code, phone: phone))
                isLoading = false
                Session.user = result.data
                newPhone = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
