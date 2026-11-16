//
//  ProviderSignupVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class ProviderSignupVM: BaseViewModel {

    @Published var signup: BaseResponse<Provider>?
    @Published var citiesList: [LookupModel] = []
    @Published var validation: Error?

    // MARK: - State -

    var isChecked: Bool = false

    // Image data
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

    func register(model: ProviderSignupModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.providerSignup(model: model))
                isLoading = false
                signup = result
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

    func validate(model: ProviderSignupModel) {
        do {
            _ = try ValidationService.validate(storeName: model.storeName)
            _ = try ValidationService.validate(password: model.password)
            _ = try ValidationService.validate(newPassword: model.password, confirmPassword: model.passwordConfirmation)
            _ = try ValidationService.validate(phone: model.phone)
            if let email = model.email, !email.isEmpty {
                _ = try ValidationService.validate(email: email)
            }
            _ = try ValidationService.validate(commercialNumber: model.commercialNumber)
            _ = try ValidationService.validate(cityId: model.cityId)
            _ = try ValidationService.validateLocation(address: model.mapDesc, lat: model.lat, long: model.lng)
            _ = try ValidationService.validate(providerIdentityImage: model.identityImageData)
            _ = try ValidationService.validate(providerCommercialImage: model.commercialImageData)
            _ = try ValidationService.validate(taxNumber: model.taxNumber)
            _ = try ValidationService.validate(establishmentName: model.establishmentName)
            _ = try ValidationService.validate(commercialEndDate: model.commercialEndDate)
            _ = try ValidationService.validate(providerPermissionImage: model.permissionImageData)
            _ = try ValidationService.validate(permissionEndDate: model.permissionEndDate)
            _ = try ValidationService.validate(bankName: model.bankName)
            _ = try ValidationService.validate(bankAccountNumber: model.bankAccountNumber)
            _ = try ValidationService.validate(iban: model.iban)
            try ValidationService.validate(termesAgreed: isChecked)
            register(model: model)
        } catch {
            validation = error
        }
    }
}
