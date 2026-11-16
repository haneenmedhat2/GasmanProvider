//
//  ProfileVM.swift
//  Esterad
//
//  Created by Haneen on 02/11/2025.
//

import Foundation
import Combine

final class ProfileVM: BaseViewModel {
    
    var profile: PassthroughSubject<User, Never> = .init()
    
    func profileRequest() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.profile())
                guard let user = result.data else { return }
                Session.user = user
                profile.send(user)
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
