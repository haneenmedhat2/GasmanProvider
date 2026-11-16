//
//  ContactUsModel.swift
//  Esterad
//
//  Created by Haneen on 09/11/2025.
//

import Foundation

struct ContactUsDataResponse: Codable {
    let contactImage: String?
    let email: String?
    let phone: String?
    let mapDesc: String?
    let lat: String?
    let lng: String?

    enum CodingKeys: String, CodingKey {
        case contactImage = "contact_image"
        case email, phone
        case mapDesc = "map_desc"
        case lat, lng
    }
}

struct ContactUsModel : Codable {
    let name : String?
    let email : String?
    let subject : String?
    var images: [Data] = []
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        
        for (index, imageData) in images.enumerated() {
            files.append(
                UploadData(
                    key: "images[\(index)]",
                    data: imageData,
                    mimeType: .jpeg,
                    fileName: "image_\(index)_\(Date().timeIntervalSince1970).jpeg"
                )
            )
        }
        
        return files
    }
}
