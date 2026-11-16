//
//  AuthEndpoints.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation
import Alamofire

struct AuthEndpoints {
    private init() {}
}

extension AuthEndpoints {
    
    static func login(model : LoginModel) -> Endpoint<BaseResponse<User>>{
        return .init(
            method: .post,
            path: "delegate/sign-in",
            body: [
                "phone": model.phone,
                "password": model.password,
                "mac_address" : nil,
                "device_id": UserDefaults.pushNotificationToken ?? "",
                "device_type": "ios",
                "country_code" : "966"
            ]
        )
    }
    
    static func signup(model: SignupModel) -> Endpoint<BaseResponse<User>> {
        return .init(
            method: .post,
            path: "delegate/sign-up",
            body: [
                
                "first_name": model.firstName,
                "last_name": model.lastName,
                "phone": model.phone,
                "email": model.email,
                "country_code": model.countryCode ?? "966",
                "password": model.password,
                "password_confirmation": model.passwordConfirmation,
                "identity_number": model.identityNumber,
                "type": model.type,
                
                "city_id": model.cityId,
                "provider_id": model.providerId,
                
                "car_type_id": model.carTypeId,
                "car_model_id": model.carModelId,
                
                "vehicle_license_plate": model.vehicleLicensePlate,
                "vehicle_serial_number": model.vehicleSerialNumber,
                
                "lat": model.lat,
                "lng": model.lng,
                "map_desc": model.mapDesc,
                
                "delegate_dates": [
                    "identity_number_end_date": model.identityNumberEndDate,
                    "driver_identity_end_date": model.driverIdentityEndDate,
                    "vehicle_operating_license_end_date": model.vehicleOperatingLicenseEndDate,
                    "identity_image_end_date": model.identityImageEndDate,
                    "vehicle_registration_license_date": model.vehicleRegistrationLicenseDate,
                    "driving_license_end_date": model.drivingLicenseEndDate,
                    "vehicle_insurance_end_date": model.vehicleInsuranceEndDate,
                    "periodic_check_up_date": model.periodicCheckUpDate
                ],
                
                "delegate_images": [
                    "image": model.image,
                    "identity_image": model.identityImage,
                    "driver_identity_image": model.driverIdentityImage,
                    "vehicle_operating_license_image": model.vehicleOperatingLicenseImage,
                    "driving_license_image": model.drivingLicenseImage,
                    "vehicle_registration_license_image": model.vehicleRegistrationLicenseImage,
                    "vehicle_insurance_image": model.vehicleInsuranceImage,
                    "periodic_check_up_image": model.periodicCheckUpImage,
                    "other_image": model.otherImage,
                    "vehicle_front_image": model.vehicleFrontImage,
                    "vehicle_back_image": model.vehicleBackImage,
                    "vehicle_right_image": model.vehicleRightImage,
                    "vehicle_left_image": model.vehicleLeftImage
                ],

                "lang": Language.apiLanguage()
            ]
        )
    }

    static func delegateUploadImage(model : UploadImageModel) -> Endpoint<BaseResponse<UploadImageResponse>>{
        return .init(
            method: .post,
            path: "delegate/upload-image",
            body: [
                "image_type" : model.imageType
            ],
            uploads: model.uploadData
        )
    }
    
    static func getCities() -> Endpoint<BaseResponse<[LookupModel]>>{
        return .init(
            method: .get,
            path: "cities"
        )
    }
    
    static func getNeighborhoods(cityId : Int) -> Endpoint<BaseResponse<[LookupModel]>>{
        return .init(
            method: .get,
            path: "neighborhoods/\(cityId)"
        )
    }
    
    static func getDelegateCompanies() -> Endpoint<BaseResponse<[LookupModel]>>{
        return .init(
            method: .get,
            path: "delegate-companies"
        )
    }

    static func getProviders() -> Endpoint<BaseResponse<[LookupModel]>> {
        return .init(
            method: .get,
            path: "delegate/providers"
        )
    }
    
    static func getCarTypes() -> Endpoint<BaseResponse<[LookupModel]>>{
        return .init(
            method: .get,
            path: "car-types"
        )
    }
    
    static func getCarModels(carTypeId : Int) -> Endpoint<BaseResponse<[LookupModel]>>{
        return .init(
            method: .get,
            path: "car-models/\(carTypeId)"
        )
    }
    
    static func providerLogin(model: LoginModel) -> Endpoint<BaseResponse<Provider>> {
        return .init(
            method: .post,
            path: "provider/sign-in",
            body: [
                "phone": model.phone,
                "password": model.password,
                "country_code": "966",
                "device_id": UserDefaults.pushNotificationToken ?? "",
                "device_type": "ios"
            ]
        )
    }

    static func providerSignup(model: ProviderSignupModel) -> Endpoint<BaseResponse<Provider>> {
        return .init(
            method: .post,
            path: "provider/sign-up",
            body: [
                "name": model.name,
                "store_name": model.storeName,
                "phone": model.phone,
                "email": model.email,
                "country_code": model.countryCode ?? "966",
                "password": model.password,
                "password_confirmation": model.passwordConfirmation,
                "commercial_number": model.commercialNumber,
                "commercial_end_date": model.commercialEndDate,
                "tax_number": model.taxNumber,
                "establishment_name": model.establishmentName,
                "city_id": model.cityId,
                "lat": model.lat,
                "lng": model.lng,
                "map_desc": model.mapDesc,
                "permission_end_date": model.permissionEndDate,
                "bank_name": model.bankName,
                "bank_account_number": model.bankAccountNumber,
                "iban": model.iban,
                "lang": Language.apiLanguage()
            ],
            uploads: model.uploadData
        )
    }

    static func verification(model : VerificationModel) -> Endpoint<BaseResponse<User>> {
        return .init(
            method: .patch,
            path: "delegate/activate",
            body: [
                "code": model.code,
                "country_code" : model.countryCode,
                "phone" : model.phone,
                "device_id" : model.deviceId,
                "device_type" : model.deviceType
            ]
        )
    }

    static func resendCode(phone : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/resend-code",
            body: [
                "country_code" : "966",
                "phone" : phone
            ]
        )
    }

    static func providerVerification(model: VerificationModel) -> Endpoint<BaseResponse<Provider>> {
        return .init(
            method: .patch,
            path: "provider/activate",
            body: [
                "code": model.code,
                "country_code": model.countryCode,
                "phone": model.phone,
                "device_id": model.deviceId,
                "device_type": model.deviceType
            ]
        )
    }

    static func providerResendCode(phone: String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/resend-code",
            body: [
                "country_code": "966",
                "phone": phone
            ]
        )
    }
    
    static func forgetPassword(phone: String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/forget-password-send-code",
            body: [
                "phone": phone,
                "country_code": "966"
            ]
        )
    }
    
    static func forgetPasswordCheckCode(phone: String , code : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/forget-password-check-code",
            body: [
                "phone": phone,
                "country_code": "966",
                "code" : code
            ]
        )
    }
    
    static func forgetPasswordResendCode(phone : String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/forget-password-resend-code",
            body: [
                "country_code" : "966",
                "phone" : phone
            ]
        )
    }
    
    static func resetPassword(model : ResetPasswordModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/reset-password",
            body: [
                "country_code" : "966",
                "phone" : model.phone,
                "code" : model.code,
                "password" : model.password,
                "password_confirmation" : model.passwordConfirmation
            ]
        )
    }

    // MARK: - Provider Forget Password -

    static func providerForgetPassword(phone: String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/forget-password-send-code",
            body: [
                "phone": phone,
                "country_code": "966"
            ]
        )
    }

    static func providerForgetPasswordCheckCode(phone: String, code: String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/forget-password-check-code",
            body: [
                "phone": phone,
                "country_code": "966",
                "code": code
            ]
        )
    }

    static func providerForgetPasswordResendCode(phone: String) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/forget-password-resend-code",
            body: [
                "country_code": "966",
                "phone": phone
            ]
        )
    }

    static func providerResetPassword(model: ResetPasswordModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/reset-password",
            body: [
                "country_code": "966",
                "phone": model.phone,
                "code": model.code,
                "password": model.password,
                "password_confirmation": model.passwordConfirmation
            ]
        )
    }
}
