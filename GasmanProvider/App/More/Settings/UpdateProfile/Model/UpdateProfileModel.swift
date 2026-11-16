//
//  UpdateProfileModel.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import Foundation

struct UpdateProfileModel: Codable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let identityNumber: String?
    let cityId: Int?
    let carTypeId: Int?
    let carModelId: Int?
    let vehicleLicensePlate: String?
    let vehicleSerialNumber: String?
    let lat: Double?
    let lng: Double?
    let mapDesc: String?
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
