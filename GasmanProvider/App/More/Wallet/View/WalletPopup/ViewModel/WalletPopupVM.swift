//
//  WalletPopupVM.swift
//  Esterad
//
//  Created by Haneen on 06/12/2025.
//

import Foundation
import Combine

final class WalletPopupVM: BaseViewModel {
        
    @Published var validationError: ValidationError?

    var validatedAmount : Double = 0.0

    func validateWalletAmount(amount : String?) -> Bool {

        switch ValidationService.validateWalletRecharge(amount: amount){
            case .success(let validAmount):
            validatedAmount = validAmount
            
        case .failure(let error):
            validationError = error
            return false
        }
          return true
      }
}
