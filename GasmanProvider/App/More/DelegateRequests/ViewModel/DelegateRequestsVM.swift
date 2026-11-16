//
//  DelegateRequestsVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class DelegateRequestsVM: BaseViewModel {

    @Published var requests: [DelegateRequestItem] = []
    @Published var actionSuccess: BaseResponse<String>?

    private var currentPage = 1
    private(set) var isLastPage = false

    func resetAndFetch() {
        currentPage = 1
        isLastPage = false
        requests.removeAll()
        fetchNextPage()
    }

    func fetchNextPage() {
        guard !isLoading, !isLastPage else { return }
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.delegateRequests(page: currentPage))
                let newItems = result.data?.data ?? []
                if currentPage == 1 {
                    requests = newItems
                } else {
                    requests.append(contentsOf: newItems)
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

    func approve(id: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.approveDelegateRequest(id: id))
                actionSuccess = result
                removeRequest(id: id)
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func reject(id: Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.rejectDelegateRequest(id: id))
                actionSuccess = result
                removeRequest(id: id)
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func removeRequest(id: Int) {
        requests.removeAll { $0.id == id }
    }
}
