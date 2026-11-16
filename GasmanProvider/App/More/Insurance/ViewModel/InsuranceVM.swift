//
//  InsuranceVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class InsuranceVM: BaseViewModel {

    @Published var insurance: InsuranceResponse?
    @Published var chargeResult: BaseResponse<String>?

    func getInsurance() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.showInsurance())
                insurance = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func chargeInsurance(metalQty: Int, fiberQty: Int) {
        let cylinders: [[String: Any]] = [
            ["category_id": 1, "qty": metalQty],
            ["category_id": 2, "qty": fiberQty]
        ]
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.chargeInsurance(cylinders: cylinders))
                chargeResult = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
