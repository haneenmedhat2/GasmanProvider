//
//  TutorialVideoVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class TutorialVideoVM: BaseViewModel {

    @Published var tutorialVideo: TutorialVideoModel?

    func fetchTutorialVideo() {
        isLoading = true
        Task {
            do {
                let result = try await request(MoreEndpoints.tutorialVideo())
                tutorialVideo = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
