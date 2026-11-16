//
//  NetworkConstants.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

struct NetworkConstants {
    private init() {}
    static let domain = "https://gasman.sa"
    static let port = "4897"
    static var server: String {
        return domain + "/api/"
    }
    static var socket: String {
        "\(domain):\(port)"
    }
}
