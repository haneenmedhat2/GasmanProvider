//
//  TermsAndConditionsVM.swift
//  Esterad
//
//  Created by Haneen on 10/11/2025.
//

import Foundation
import Combine

final class TermsAndConditionsVM: BaseViewModel {
    
    @Published var termsAndConditions: BaseResponse<StaticPagesModel>?

    func termsAndConditionsRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.termsAndConditions())
                termsAndConditions = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
    
