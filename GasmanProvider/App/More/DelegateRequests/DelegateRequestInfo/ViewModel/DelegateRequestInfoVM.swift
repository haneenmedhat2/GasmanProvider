//
//  DelegateRequestInfoVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class DelegateRequestInfoVM: BaseViewModel {

    @Published var user: User?
    @Published var actionSuccess: BaseResponse<String>?

    private let requestId: Int

    init(requestId: Int) {
        self.requestId = requestId
    }

    func fetchInfo() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.delegateRequestShowInfo(id: requestId))
                user = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func approve() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.approveDelegateRequest(id: requestId))
                actionSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func reject() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.rejectDelegateRequest(id: requestId))
                actionSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
