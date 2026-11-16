//
//  SelectMerchantVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class SelectMerchantVM: BaseViewModel {

    @Published var providers: [MerchantProvider] = []
    @Published var changeProvider : BaseResponse<String>?
    
    var selectedProviderId: Int?

    func fetchProviders() {
        isLoading = true
        Task {
            do {
                let result = try await request(MerchantEndpoints.allProviders())
                providers = result?.providers ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func changeProviderRequest() {
        guard let id = selectedProviderId else { return }
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MerchantEndpoints.changeProvider(id: id))
                changeProvider = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
