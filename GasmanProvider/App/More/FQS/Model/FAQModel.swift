//
//  FAQModel.swift
//  Esterad
//
//  Created by Haneen on 10/11/2025.
//

import Foundation

struct FAQModel : Codable {
    let id : Int
    let question : String
    let answer : String
}

struct ExpandableItem {
    var title: String
    var details: String
    var isExpanded: Bool
    
    init(faq: FAQModel) {
            self.title = faq.question
            self.details = faq.answer
            self.isExpanded = false
        }
}
