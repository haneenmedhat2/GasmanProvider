//
//  ProviderUpdateProfileVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class ProviderUpdateProfileVM: BaseViewModel {
    @Published var profile: Provider?
    @Published var updateProfile: BaseResponse<String>?
    @Published var citiesList: [LookupModel] = []
    @Published var validation: Error?

    // Image data for multipart upload
    var imageData: Data?
    var identityImageData: Data?
    var commercialImageData: Data?
    var permissionImageData: Data?

    // Picker selections
    var selectedCity: SelectionModelPicker?

    // Location
    var selectedLat: Double?
    var selectedLng: Double?
    var selectedMapDesc: String?

    // MARK: - API -

    func profileRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.providerProfile())
                guard let provider = result.data else { return }
                Session.provider = provider
                profile = provider
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func updateProfileRequest(model: UpdateProviderProfileModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.updateProviderProfile(model: model))
                updateProfile = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getCities() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getCities())
                isLoading = false
                citiesList = result.data ?? []
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    // MARK: - Validation -

    func validateAndUpdate(model: UpdateProviderProfileModel) {
        do {
            _ = try ValidationService.validate(storeName: model.storeName)
            _ = try ValidationService.validate(commercialNumber: model.commercialNumber)
            _ = try ValidationService.validate(cityId: model.cityId)
            _ = try ValidationService.validateLocation(address: model.mapDesc, lat: model.lat, long: model.lng)
            _ = try ValidationService.validate(bankName: model.bankName)
            _ = try ValidationService.validate(bankAccountNumber: model.bankAccountNumber)
            _ = try ValidationService.validate(iban: model.iban)
            updateProfileRequest(model: model)
        } catch {
            validation = error
        }
    }
}
