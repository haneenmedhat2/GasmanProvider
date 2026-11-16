//
//  InvoiceDetailsVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class InvoiceDetailsVM: BaseViewModel {

    @Published var details: InvoiceDetails?

    private let invoiceId: Int

    init(invoiceId: Int) {
        self.invoiceId = invoiceId
    }

    func fetchDetails() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.invoiceDetails(id: invoiceId))
                details = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
