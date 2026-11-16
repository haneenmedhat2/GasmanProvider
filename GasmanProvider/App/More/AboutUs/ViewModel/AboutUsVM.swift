//
//  AboutUsVM.swift
//  Esterad
//
//  Created by Haneen on 11/11/2025.
//

import Foundation
import Combine

final class AboutUsVM: BaseViewModel {
    
    @Published var aboutUs: BaseResponse<StaticPagesModel>?
    
    func aboutUsRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.aboutUs())
                aboutUs = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
    
