//
//  WorkLocationsVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class WorkLocationsVM: BaseViewModel {
    @Published var workPlaces: [Neighborhood] = []

    // MARK: - API -

    func getWorkPlaces() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getWorkPlaces())
                workPlaces = result.data?.neighborhoods?.filter{ $0.isSelected ?? false } ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
