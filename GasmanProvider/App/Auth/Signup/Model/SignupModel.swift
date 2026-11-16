//
//  SignupModel.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

//MARK: - SignupModel -

struct SignupModel: Codable {
    
    let firstName: String?
    let lastName: String?
    let countryCode: String?
    let phone: String?
    let email: String?
    let password: String?
    let passwordConfirmation: String?
    let identityNumber: String?
    let type: Int? // 0 => GASMAN_APP, 1 => PROVIDER
    let cityId: Int?
    let providerId: Int?
    let carTypeId: Int?
    let carModelId: Int?
    let vehicleLicensePlate: String?
    let vehicleSerialNumber: String?
    let lat: Double?
    let lng: Double?
    let mapDesc: String?
    let lang: String?
    let identityNumberEndDate: String?
    let driverIdentityEndDate: String?
    let vehicleOperatingLicenseEndDate: String?
    let identityImageEndDate: String?
    let vehicleRegistrationLicenseDate: String?
    let drivingLicenseEndDate: String?
    let vehicleInsuranceEndDate: String?
    let periodicCheckUpDate: String?
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
}

//MARK: - Upload image -

struct UploadImageModel: Codable {
    var image : Data? = nil
    var imageType : String?
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let imageData = image {
            files.append(UploadData(
                key: "image",
                data: imageData,
                mimeType: .jpeg,
                fileName: "\(Date().timeIntervalSince1970).jpeg"
            ))
        }
        return files
    }
}

struct UploadImageResponse: Codable {
    let name: String?
    let image: String?
    let url: String?
}

// MARK: - Lookup Model -

struct LookupModel: Codable {
    let id: Int?
    let name: String?
}

extension LookupModel: SelectionModelPicker {
    var pickerId: Int { id ?? 0 }
    var pickerName: String { name ?? "" }
}

// MARK: - User -

struct User: Codable {
    let id: Int?
    let name: String?
    let phone: String?
    let email: String?
    let countryCode: String?
    let identityNumber: String?
    
    let lat: Double?
    let lng: Double?
    let mapDesc: String?
    
    let canOrder: Bool?
    let isNotify: Bool?
    let isSeenTutorialVideo: Bool?
    let lang: String?
    
  //  let rateAvg: Int?
    let rateCount: Int?
    
    let vehicleLicensePlate: String?
    let vehicleSerialNumber: String?
    
    let token: String?
    
    let city: LookupModel?
    let carModel: LookupModel?
    let carType: LookupModel?
    let type: DelegateType?
    let delegateSource: DelegateType?
    
    let neighborhoods: [LookupModel]?
    let delegateDates: [DelegateDates]?
    let delegateImages: [DelegateImages]?
    let bankInfo: BankInfo?
    
    enum CodingKeys: String, CodingKey {
        case id, name, phone, email, token, lang
        case lat, lng
        case city, neighborhoods
        case type
        case carModel = "car_model"
        case carType = "car_type"
        case countryCode = "country_code"
        case identityNumber = "identity_number"
        case mapDesc = "map_desc"
        case canOrder = "can_order"
        case isNotify = "is_notify"
        case isSeenTutorialVideo = "is_seen_tutorial_video"
     //   case rateAvg = "rate_avg"
        case rateCount = "rate_count"
        case vehicleLicensePlate = "vehicle_license_plate"
        case vehicleSerialNumber = "vehicle_serial_number"
        case delegateDates = "delegate_dates"
        case delegateImages = "delegate_images"
        case delegateSource = "delegate_source"
        case bankInfo = "bank_info"
    }
}

struct BankInfo: Codable {
    let bankName: String?
    let bankAccountNumber: String?
    let iban: String?
    
    enum CodingKeys: String, CodingKey {
        case bankName = "bank_name"
        case bankAccountNumber = "bank_account_number"
        case iban
    }
}

struct DelegateType: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?
    
    enum CodingKeys: String, CodingKey {
        case key, name, title
        case detailsText = "details_text"
    }
}

struct DelegateDates: Codable {
    let driverIdentityEndDate: String?
    let drivingLicenseEndDate: String?
    let identityImageEndDate: String?
    let identityNumberEndDate: String?
    let periodicCheckUpDate: String?
    let vehicleInsuranceEndDate: String?
    let vehicleOperatingLicenseEndDate: String?
    let vehicleRegistrationLicenseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case driverIdentityEndDate = "driver_identity_end_date"
        case drivingLicenseEndDate = "driving_license_end_date"
        case identityImageEndDate = "identity_image_end_date"
        case identityNumberEndDate = "identity_number_end_date"
        case periodicCheckUpDate = "periodic_check_up_date"
        case vehicleInsuranceEndDate = "vehicle_insurance_end_date"
        case vehicleOperatingLicenseEndDate = "vehicle_operating_license_end_date"
        case vehicleRegistrationLicenseDate = "vehicle_registration_license_date"
    }
}

struct DelegateImages: Codable {
    let image: String?
    let identityImage: String?
    let driverIdentityImage: String?
    let drivingLicenseImage: String?
    let vehicleOperatingLicenseImage: String?
    let vehicleRegistrationLicenseImage: String?
    let vehicleInsuranceImage: String?
    let periodicCheckUpImage: String?
    let vehicleFrontImage: String?
    let vehicleBackImage: String?
    let vehicleLeftImage: String?
    let vehicleRightImage: String?
    let otherImage: String?
    
    enum CodingKeys: String, CodingKey {
        case image
        case identityImage = "identity_image"
        case driverIdentityImage = "driver_identity_image"
        case drivingLicenseImage = "driving_license_image"
        case vehicleOperatingLicenseImage = "vehicle_operating_license_image"
        case vehicleRegistrationLicenseImage = "vehicle_registration_license_image"
        case vehicleInsuranceImage = "vehicle_insurance_image"
        case periodicCheckUpImage = "periodic_check_up_image"
        case vehicleFrontImage = "vehicle_front_image"
        case vehicleBackImage = "vehicle_back_image"
        case vehicleLeftImage = "vehicle_left_image"
        case vehicleRightImage = "vehicle_right_image"
        case otherImage = "other_image"
    }
}
