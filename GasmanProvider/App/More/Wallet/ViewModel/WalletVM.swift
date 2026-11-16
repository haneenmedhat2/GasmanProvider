//
//  WalletVM.swift
//  Esterad
//
//  Created by Haneen on 05/11/2025.
//

import Foundation
import Combine

final class WalletVM: BaseViewModel {
    
    @Published var showWallet: BaseResponse<WalletResponse>?
    @Published var chargeWallet: BaseResponse<String>?
    
    func showWalletRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.showWallet())
                showWallet = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func chargeWalletRequest(amount : Double){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.chargeWallet(amount: amount))
                chargeWallet = result
                showWalletRequest()
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
