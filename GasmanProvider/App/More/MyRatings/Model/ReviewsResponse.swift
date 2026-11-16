//
//  ReviewsResponse.swift
//  GasMan
//
//  Created by Haneen on 18/02/2026.
//


struct ReviewsResponse : Codable {
    let rates : [Reviews]
}

struct Reviews : Codable {
    let comment : String?
    let id : Int?
    let rate : Int?
    let rater : Reviewer?
}

struct Reviewer : Codable {
    let id : Int?
    let name : String?
    let image : String?
}
