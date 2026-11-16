//
//  SettlementVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class SettlementVM: BaseViewModel {

    @Published var settlement: SettlementCashResponse?

    func fetchSettlementCashReceived() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.settlementCashReceived())
                settlement = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
