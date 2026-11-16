//
//  SignupVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class SignupVM: BaseViewModel {

    @Published var signup: BaseResponse<User>?
    @Published var citiesList: [LookupModel] = []
    @Published var providersList: [LookupModel] = []
    @Published var carTypesList: [LookupModel] = []
    @Published var carModelsList: [LookupModel] = []
    @Published var validation: Error?

    // MARK: - State -

    var isChecked: Bool = false

    // Profile & identity images (stored as server-returned filename strings after upload)
    var image: String?
    var identityImage: String?
    var driverIdentityImage: String?
    var vehicleOperatingLicenseImage: String?
    var drivingLicenseImage: String?
    var vehicleRegistrationLicenseImage: String?
    var vehicleInsuranceImage: String?
    var periodicCheckUpImage: String?
    var otherImage: String?
    var vehicleFrontImage: String?
    var vehicleBackImage: String?
    var vehicleRightImage: String?
    var vehicleLeftImage: String?

    // Picker selections
    var selectedCity: SelectionModelPicker?
    var selectedProvider: SelectionModelPicker?
    var selectedCarType: SelectionModelPicker?
    var selectedCarModel: SelectionModelPicker?

    // Location
    var selectedLat: Double?
    var selectedLng: Double?
    var selectedMapDesc: String?
    
    var typeOptionsList: [SelectionOptionType] = [.provider, .gasmanApp]

    // MARK: - API -

    private var pendingUploadsCount: Int = 0

    func uploadImage(data: Data, imageType: String?, completion: @escaping (String?) -> Void) {
        let model = UploadImageModel(image: data, imageType: imageType)
        pendingUploadsCount += 1
        Task {
            do {
                let result = try await request(AuthEndpoints.delegateUploadImage(model: model))
                pendingUploadsCount -= 1
                completion(result?.image)
            } catch {
                pendingUploadsCount -= 1
                self.error = error
                completion(nil)
            }
        }
    }

    func register(model: SignupModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.signup(model: model))
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

    func getProviders() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getProviders())
                isLoading = false
                providersList = result.data ?? []
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getCarTypes() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getCarTypes())
                isLoading = false
                carTypesList = result.data ?? []
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func getCarModels(carTypeId : Int) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(AuthEndpoints.getCarModels(carTypeId: carTypeId))
                isLoading = false
                carModelsList = result.data ?? []
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    // MARK: - Validation -

    var stepValidatedSubject = PassthroughSubject<Void, Never>()

    func validate(step: Int, model: SignupModel) {
        guard pendingUploadsCount == 0 else {
            validation = ValidationError.imageUploadInProgress
            return
        }
        do {
            switch step {
            case 0: try validateStep0(model: model)
            case 1: try validateStep1(model: model)
            case 2: try validateStep2(model: model)
            default: break
            }
            if step < 2 { stepValidatedSubject.send() }
        } catch {
            validation = error
        }
    }

    private func validateStep0(model: SignupModel) throws {
        _ = try ValidationService.validate(profilePicture: model.image)
        _ = try ValidationService.validate(firstName: model.firstName)
        _ = try ValidationService.validate(familyName: model.lastName)
        _ = try ValidationService.validate(phone: model.phone)
        if model.type == 1 { _ = try ValidationService.validate(providerId: model.providerId) }
        _ = try ValidationService.validate(password: model.password)
        _ = try ValidationService.validate(newPassword: model.password, confirmPassword: model.passwordConfirmation)
        if let email = model.email { _ = try ValidationService.validate(email: email) }
        _ = try ValidationService.validate(identityNumber: model.identityNumber)
        _ = try ValidationService.validate(cityId: model.cityId)
        _ = try ValidationService.validateLocation(address: model.mapDesc, lat: model.lat, long: model.lng)
        _ = try ValidationService.validate(carTypeId: model.carTypeId)
        _ = try ValidationService.validate(carModelId: model.carModelId)
        _ = try ValidationService.validate(carPlate: model.vehicleLicensePlate)
    }

    private func validateStep1(model: SignupModel) throws {
        _ = try ValidationService.validate(vehicleSerialNumber: model.vehicleSerialNumber)
        _ = try ValidationService.validate(driverIdentityImage: model.driverIdentityImage)
        _ = try ValidationService.validate(driverIdentityEndDate: model.driverIdentityEndDate)
        _ = try ValidationService.validate(vehicleOperatingLicenseImage: model.vehicleOperatingLicenseImage)
        _ = try ValidationService.validate(vehicleOperatingLicenseEndDate: model.vehicleOperatingLicenseEndDate)
        _ = try ValidationService.validate(nationalIdentityImage: model.identityImage)
        _ = try ValidationService.validate(identityImageEndDate: model.identityImageEndDate)
        _ = try ValidationService.validate(drivingLicenseImage: model.drivingLicenseImage)
        _ = try ValidationService.validate(drivingLicenseEndDate: model.drivingLicenseEndDate)
        _ = try ValidationService.validate(vehicleRegistrationImage: model.vehicleRegistrationLicenseImage)
        _ = try ValidationService.validate(vehicleRegistrationLicenseDate: model.vehicleRegistrationLicenseDate)
        _ = try ValidationService.validate(vehicleInsuranceImage: model.vehicleInsuranceImage)
    }

    private func validateStep2(model: SignupModel) throws {
        _ = try ValidationService.validate(vehicleInsuranceEndDate: model.vehicleInsuranceEndDate)
        _ = try ValidationService.validate(periodicCheckUpImage: model.periodicCheckUpImage)
        _ = try ValidationService.validate(periodicCheckUpDate: model.periodicCheckUpDate)
        _ = try ValidationService.validate(otherImage: model.otherImage)
        _ = try ValidationService.validate(vehicleFrontImage: model.vehicleFrontImage)
        _ = try ValidationService.validate(vehicleBackImage: model.vehicleBackImage)
        _ = try ValidationService.validate(vehicleRightImage: model.vehicleRightImage)
        _ = try ValidationService.validate(vehicleLeftImage: model.vehicleLeftImage)
        try ValidationService.validate(termesAgreed: isChecked)
        register(model: model)
    }
}
