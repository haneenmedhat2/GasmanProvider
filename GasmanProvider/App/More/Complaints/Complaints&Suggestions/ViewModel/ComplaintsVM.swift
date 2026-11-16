//
//  ComplaintsVM.swift
//  Esterad
//
//  Created by Haneen on 06/11/2025.
//

import Foundation
import Combine
import UIKit

final class ComplaintsVM: BaseViewModel {
    
    @Published var complaint: BaseResponse<String>?
    @Published var validationError: Error?
    
    var complaintsList : [SelectionOptionType] = [.complaint,.suggestion]
    var indexPath : IndexPath  = IndexPath(row: 0, section: 0 )
    
    func sendComplaintsRequest(model : ComplaintsModel){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.sendComplaints(model: model))
                complaint = result
                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func validateInputs(model: ComplaintsModel){
        do {
            _ = try ValidationService.validate(complaintTitle: model.subject)
            _ = try ValidationService.validate(complaintDetails:  model.complaint)
            sendComplaintsRequest(model: model)
        } catch {
            validationError = error
        }
    }
}
