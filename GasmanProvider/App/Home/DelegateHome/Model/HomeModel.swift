//
//  HomeModel.swift
//  Esterad
//
//  Created by Haneen on 11/11/2025.
//

import Foundation

struct HomeResponse: Codable {
    let orders: [ClientOrder]?
    let pagination: Pagination?
}
