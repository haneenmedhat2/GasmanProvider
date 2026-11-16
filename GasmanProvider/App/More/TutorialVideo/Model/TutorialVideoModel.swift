//
//  TutorialVideoModel.swift
//  GasmanProvider
//

import Foundation

struct TutorialVideoModel: Codable {
    let title: String?
    let tutorialVideo: String?

    enum CodingKeys: String, CodingKey {
        case title
        case tutorialVideo = "tutorial_video"
    }
}
