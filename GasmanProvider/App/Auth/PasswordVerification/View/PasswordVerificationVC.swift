//
//  PasswordVerificationVC.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import UIKit
import Combine

class PasswordVerificationVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var verificationView: VerificationView!
    
    //MARK: - Properties -
    
    var viewModel : PasswordVerificationVMProtocol
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : PasswordVerificationVMProtocol, ){
        self.viewModel = viewModel
        super.init(nibName: "PasswordVerificationVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        verificationView.getPhoneNumber(phone : viewModel.phone)
        verificationView.delegate = self
        bindViewModel()
        viewModel.startCountdown()
    }
    
    //MARK: - View Model Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.verificationPublisher
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                goToResetPassword()
            }
            .store(in: &cancellables)
        
        viewModel.remainingTimePublisher
            .sinkOnMain{ [weak self] time in
                guard let self = self else { return }
                self.verificationView.updateTimer(time: time)
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.isResendEnabledPublisher
            .sinkOnMain{ [weak self] isEnabled in
                guard let self = self else { return }
                self.verificationView.setResendEnabled(isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.resendCodePublisher
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result?.message ?? "")
                viewModel.startCountdown()
            }
            .store(in: &cancellables)
        
        error(viewModel.errorPublisher)
    }
    
}

//MARK: - Routes -

extension PasswordVerificationVC {
    
    func goToResetPassword() {
        let vc = ResetPasswordVC(viewModel: ResetPasswordVM(phone: viewModel.phone, code: viewModel.otp))
        push(vc)
    }
}

//MARK: - Delegation -

extension PasswordVerificationVC: VerificationViewDelegate {
    
    func didTapConfirm(otp: String) {
         viewModel.validateOTP(otp: otp)
    }
    
    func didTapResend() {
        viewModel.resendCodeRequest()
    }
}


