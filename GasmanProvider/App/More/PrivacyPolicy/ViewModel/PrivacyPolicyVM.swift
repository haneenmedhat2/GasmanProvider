//
//  PrivacyPolicyVM.swift
//  Profix
//
//  Created by Haneen on 29/12/2025.
//


import Foundation
import Combine

final class PrivacyPolicyVM: BaseViewModel {
    
    @Published var privacy: BaseResponse<StaticPagesModel>?

    func privacyPolicyRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.privacyPolicy())
                privacy = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
