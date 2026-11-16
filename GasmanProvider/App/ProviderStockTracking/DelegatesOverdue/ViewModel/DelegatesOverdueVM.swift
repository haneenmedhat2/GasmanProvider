//
//  DelegatesOverdueVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class DelegatesOverdueVM: BaseViewModel {

    @Published var response: BaseResponse<DelegatesOverdueResponse>?

    var delegatesList: [DelegateOverdue] = []
    var currentPage: Int = 1
    var isLastPage: Bool = false

    func getDelegatesOverdue() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    StockTrackingEndpoints.delegatesOverdue(page: currentPage)
                )

                let newDelegates = result.data?.delegates ?? []

                if currentPage == 1 {
                    delegatesList.removeAll()
                    delegatesList = newDelegates
                } else {
                    delegatesList.append(contentsOf: newDelegates)
                }

                isLastPage = result.data?.pagination.isLastPage ?? false
                if !isLastPage {
                    currentPage += 1
                }

                isLoading = false
                response = result
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func resetData() {
        currentPage = 1
        isLastPage = false
    }
}
