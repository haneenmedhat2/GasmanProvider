//
//  ProviderSignupModel.swift
//  GasmanProvider
//

import Foundation

struct ProviderSignupModel {
    let name: String?
    let storeName: String?
    let email: String?
    let countryCode: String?
    let phone: String?
    let password: String?
    let passwordConfirmation: String?
    let commercialNumber: String?
    let commercialEndDate: String?
    let taxNumber: String?
    let establishmentName: String?
    let cityId: Int?
    let lat: Double?
    let lng: Double?
    let mapDesc: String?
    let permissionEndDate: String?
    let bankName: String?
    let bankAccountNumber: String?
    let iban: String?

    // Image data (uploaded as multipart)
    var imageData: Data?
    var identityImageData: Data?
    var commercialImageData: Data?
    var permissionImageData: Data?

    var uploadData: [UploadData] {
        var files = [UploadData]()
        if let data = imageData {
            files.append(UploadData(key: "image", data: data, mimeType: .jpeg,
                                    fileName: "profile_\(Date().timeIntervalSince1970).jpeg"))
        }
        if let data = identityImageData {
            files.append(UploadData(key: "identity_image", data: data, mimeType: .jpeg,
                                    fileName: "identity_\(Date().timeIntervalSince1970).jpeg"))
        }
        if let data = commercialImageData {
            files.append(UploadData(key: "commercial_image", data: data, mimeType: .jpeg,
                                    fileName: "commercial_\(Date().timeIntervalSince1970).jpeg"))
        }
        if let data = permissionImageData {
            files.append(UploadData(key: "permission_image", data: data, mimeType: .jpeg,
                                    fileName: "permission_\(Date().timeIntervalSince1970).jpeg"))
        }
        return files
    }
}
