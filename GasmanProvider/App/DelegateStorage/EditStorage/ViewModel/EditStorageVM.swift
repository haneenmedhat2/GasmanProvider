//
//  EditStorageVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class EditStorageVM: BaseViewModel {

    @Published var steelQty: Int
    @Published var fiberQty: Int
    @Published var updateSuccess: BaseResponse<StorageUpdateResponse>?

    init(steelQty: Int = 0, fiberQty: Int = 0) {
        self.steelQty = max(0, steelQty)
        self.fiberQty = max(0, fiberQty)
    }

    func incrementSteel() { steelQty += 1 }
    func decrementSteel() { steelQty = max(0, steelQty - 1) }
    func incrementFiber() { fiberQty += 1 }
    func decrementFiber() { fiberQty = max(0, fiberQty - 1) }

    func submit() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MoreEndpoints.updateStorage(steelFullQty: steelQty, fiberFullQty: fiberQty)
                )
                updateSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
