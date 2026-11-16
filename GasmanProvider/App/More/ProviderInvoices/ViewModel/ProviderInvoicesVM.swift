//
//  ProviderInvoicesVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class ProviderInvoicesVM: BaseViewModel {

    @Published var invoices: [InvoiceItem] = []

    var selectedTab: InvoiceTab = .customer

    private var currentPage = 1
    private(set) var isLastPage = false

    func resetAndFetch() {
        currentPage = 1
        isLastPage = false
        invoices.removeAll()
        fetchNextPage()
    }

    func fetchNextPage() {
        guard !isLoading, !isLastPage else { return }
        isLoading = true
        let endpoint = selectedTab == .customer
            ? MoreEndpoints.customerInvoices(page: currentPage)
            : MoreEndpoints.providerInvoices(page: currentPage)
        Task {
            do {
                let result = try await getAllRequest(endpoint)
                let newItems = result.data?.data ?? []
                if currentPage == 1 {
                    invoices = newItems
                } else {
                    invoices.append(contentsOf: newItems)
                }
                isLastPage = result.data?.pagination?.isLastPage ?? true
                if !isLastPage { currentPage += 1 }
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
