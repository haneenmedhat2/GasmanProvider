//
//  VerificationModel.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

struct VerificationModel : Codable {
    let code : String
    let countryCode : String
    let phone : String
    let deviceId : String
    let deviceType : String
}
