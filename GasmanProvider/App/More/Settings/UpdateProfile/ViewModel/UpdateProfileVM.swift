//
//  UpdateProfileVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class UpdateProfileVM: BaseViewModel {
    @Published var profile: User?
    @Published var updateProfile: BaseResponse<String>?
    @Published var citiesList: [LookupModel] = []
    @Published var carTypesList: [LookupModel] = []
    @Published var carModelsList: [LookupModel] = []
    @Published var validation: Error?

    // Image URLs (server-returned strings after upload)
    var image: String?
    var identityImage: String?
    var vehicleOperatingLicenseImage: String?
    var drivingLicenseImage: String?
    var vehicleRegistrationLicenseImage: String?
    var vehicleInsuranceImage: String?
    var vehicleFrontImage: String?
    var vehicleBackImage: String?
    var vehicleRightImage: String?
    var vehicleLeftImage: String?

    // Picker selections
    var selectedCity: SelectionModelPicker?
    var selectedCarType: SelectionModelPicker?
    var selectedCarModel: SelectionModelPicker?

    // Location
    var selectedLat: Double?
    var selectedLng: Double?
    var selectedMapDesc: String?

    // MARK: - API -

    func profileRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.profile())
                guard let user = result.data else { return }
                Session.user = user
                profile = user
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func uploadImage(data: Data, imageType: String?, completion: @escaping (String?) -> Void) {
        let model = UploadImageModel(image: data, imageType: imageType)
        isLoading = true
        Task {
            do {
                let result = try await request(AuthEndpoints.delegateUploadImage(model: model))
                completion(result?.image)
                isLoading = false
            } catch {
                self.error = error
                completion(nil)
                isLoading = false

            }
        }
    }

    func updateProfileRequest(model: UpdateProfileModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.updateProfile(model: model))
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

    func getCarModels(carTypeId: Int) {
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

    func validateAndUpdate(model: UpdateProfileModel) {
        do {
            _ = try ValidationService.validate(firstName: model.firstName)
            _ = try ValidationService.validate(familyName: model.lastName)
            if let email = model.email, !email.trimWhiteSpace().isEmpty {
                _ = try ValidationService.validate(email: email)
            }
            _ = try ValidationService.validate(identityNumber: model.identityNumber)
            _ = try ValidationService.validate(cityId: model.cityId)
            _ = try ValidationService.validateLocation(address: model.mapDesc, lat: model.lat, long: model.lng)
            _ = try ValidationService.validate(vehicleOperatingLicenseImage: model.vehicleOperatingLicenseImage)
            _ = try ValidationService.validate(vehicleRegistrationImage: model.vehicleRegistrationLicenseImage)
            _ = try ValidationService.validate(nationalIdentityImage: model.identityImage)
            _ = try ValidationService.validate(drivingLicenseImage: model.drivingLicenseImage)
            _ = try ValidationService.validate(drivingLicenseEndDate: model.drivingLicenseEndDate)
            _ = try ValidationService.validate(vehicleInsuranceImage: model.vehicleInsuranceImage)
            _ = try ValidationService.validate(vehicleInsuranceEndDate: model.vehicleInsuranceEndDate)
            _ = try ValidationService.validate(carTypeId: model.carTypeId)
            _ = try ValidationService.validate(carModelId: model.carModelId)
            _ = try ValidationService.validate(carPlate: model.vehicleLicensePlate)
            _ = try ValidationService.validate(vehicleSerialNumber: model.vehicleSerialNumber)
            _ = try ValidationService.validate(vehicleFrontImage: model.vehicleFrontImage)
            _ = try ValidationService.validate(vehicleBackImage: model.vehicleBackImage)
            _ = try ValidationService.validate(vehicleRightImage: model.vehicleRightImage)
            _ = try ValidationService.validate(vehicleLeftImage: model.vehicleLeftImage)
            updateProfileRequest(model: model)
        } catch {
            validation = error
        }
    }
}
