//
//  AddWorkPlaceVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class AddWorkPlaceVM: BaseViewModel {
    @Published var neighborhoods: [Neighborhood] = []
    @Published var toggleResult: BaseResponse<String>?

    // MARK: - API -

    func getNeighborhoods() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getWorkPlaces())
                neighborhoods = result.data?.neighborhoods ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func toggleWorkPlaces() {
        let selectedIds = neighborhoods.compactMap { $0.isSelected == true ? $0.id : nil }
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.toggleWorkPlaces(neighborhoodIds: selectedIds))
                toggleResult = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
