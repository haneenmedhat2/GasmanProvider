//
//  ChangePhoneVM.swift
//  Esterad
//
//  Created by Haneen on 04/11/2025.
//

import Foundation
import Combine

final class ChangePhoneVM: BaseViewModel {
    
    @Published var changePhone: BaseResponse<String>?
    @Published var validation: Error?
    
    func changePhoneRequest(phone :String){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.sendCodeNewPhone(phone: phone))
                isLoading = false
                changePhone = result
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validatePhone(phone: String?)  {
        do{
            let validatedPhone =  try ValidationService.validate(phone: phone)
            changePhoneRequest(phone :validatedPhone)
            
        } catch {
            validation = error
        }
    }
}
