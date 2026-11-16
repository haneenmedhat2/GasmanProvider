//
//  MyRatingsVM.swift
//  GasMan
//
//  Created by Haneen on 18/02/2026.
//


import Foundation
import Combine

final class MyRatingsVM : BaseViewModel {
    
    @Published var reviews : [Reviews] = []
    
    func getReviews(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getReviews())
                isLoading = false
                reviews = result.data?.rates ?? []
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
