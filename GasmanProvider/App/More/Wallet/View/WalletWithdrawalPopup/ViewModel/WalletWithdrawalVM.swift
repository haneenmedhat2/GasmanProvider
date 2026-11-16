//
//  WalletWithdrawalVM.swift
//  GasMan
//
//  Created by Haneen on 10/02/2026.
//

import Foundation
import Combine

final class WalletWithdrawalVM: BaseViewModel {
    
    @Published var validation: Error?
    @Published var withdrawalAmount: BaseResponse<String>?
    
    func withdrawMoney(model : WithdrawMoney){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.withdrawMoney(model: model))
                withdrawalAmount = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func validateData(model: WithdrawMoney)  {
        do {
            _ = try ValidationService.validate(amount: model.amount)
            _ = try ValidationService.validate(bankName: model.bankName)
            _ = try ValidationService.validate(bankAccountNumber: model.bankAccountNumber)
            _ = try ValidationService.validate(iban: model.iban)
            withdrawMoney(model: model)
            
        }catch {
            validation = error
        }
    }
}
