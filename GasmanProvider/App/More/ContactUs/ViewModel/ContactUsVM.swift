//
//  ContactUsVM.swift
//  Esterad
//
//  Created by Haneen on 09/11/2025.
//

import Foundation
import Combine

protocol ContactUsVMProtocol {

    var contactUsPublisher: Published<BaseResponse<String>?>.Publisher { get }
    var contactUsDataPublisher: Published<BaseResponse<ContactUsDataResponse>?>.Publisher { get }
    var validationPublisher: Published<Error?>.Publisher { get }

    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: Published<Error?>.Publisher { get }

    func validateInputs(model: ContactUsModel)
    func fetchContactUsData()
}

final class ContactUsVM: BaseViewModel,ContactUsVMProtocol {

    @Published var contactUs: BaseResponse<String>?
    @Published var contactUsData: BaseResponse<ContactUsDataResponse>?
    @Published var validationError: Error?

    var contactUsPublisher: Published<BaseResponse<String>?>.Publisher { $contactUs }
    var contactUsDataPublisher: Published<BaseResponse<ContactUsDataResponse>?>.Publisher { $contactUsData }
    var validationPublisher: Published<Error?>.Publisher { $validationError }

    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var errorPublisher: Published<Error?>.Publisher { $error }

    func fetchContactUsData() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.contactUsData())
                contactUsData = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func contactUs(model: ContactUsModel) {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MoreEndpoints.contactUs(model: model)
                )
                contactUs = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }


    func validateInputs(model: ContactUsModel)  {
        do {
            _ = try ValidationService.validate(name: model.name)
            _ = try ValidationService.validate(email: model.email)
            contactUs(model: model)
        } catch {
            validationError = error
        }
    }

}
