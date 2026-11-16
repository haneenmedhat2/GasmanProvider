//
//  NeighborhoodsResponse.swift
//  GasmanProvider
//
//  Created by Haneen on 18/03/2026.
//


// MARK: - Data -

struct NeighborhoodsResponse: Codable {
    let neighborhoods: [Neighborhood]?
    let pagination: Pagination?
}

// MARK: - Neighborhood -

struct Neighborhood: Codable {
    let id: Int?
    let name: String?
    var isSelected: Bool?
    let city: City?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isSelected = "is_selected"
        case city
    }
}

// MARK: - City -

struct City: Codable {
    let id: Int?
    let name: String?
}
