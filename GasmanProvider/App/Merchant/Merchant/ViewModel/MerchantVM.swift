//
//  MerchantVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class MerchantVM: BaseViewModel {

    @Published var provider: MerchantProvider? = nil

    func fetchProfile() {
        isLoading = true
        Task {
            do {
                let result = try await request(MerchantEndpoints.providerProfile())
                provider = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
