//
//  ChangePhoneVerifyVC.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import UIKit
import Combine

class ChangePhoneVerifyVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var verificationView: VerificationView!
    
    //MARK: - Properties -
    
    var viewModel : ChangePhoneVerifyVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ChangePhoneVerifyVMProtocol, ){
        self.viewModel = viewModel
        super.init(nibName: "ChangePhoneVerifyVC", bundle: nil)
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
        self.title = "Verification_code".localized
        verificationView.getPhoneNumber(phone : viewModel.phone)
        verificationView.headerStackView.isHidden = true
        verificationView.delegate = self
        if viewModel.mode == .oldPhone {
            viewModel.sendCurrentPhoneCode()
        }
        bindViewModel()
        viewModel.startCountdown()
    }
    
    //MARK: - View Model Binding -
    
    private func bindViewModel() {
        loading(viewModel.isLoadingPublisher)
        
        viewModel.oldPhoneCodePublisher
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.verificationPublisher
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                self.goToChangePhone()
            }
            .store(in: &cancellables)
        
        viewModel.newPhonePublisher
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                self.goToSettings()
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

extension ChangePhoneVerifyVC {
    
    func goToChangePhone(){
        let vc = ChangePhoneVC(viewModel: ChangePhoneVM())
        push(vc)
    }
    
    func goToSettings(){
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeAll { $0 is ChangePhoneVC }
        navigationController?.viewControllers = viewControllers
        
        pop()
    }
}

//MARK: - Delegation -

extension ChangePhoneVerifyVC: VerificationViewDelegate {
    
    func didTapConfirm(otp: String) {
        viewModel.validateOTP(otp: otp)
    }
    
    func didTapResend() {
        viewModel.resendCodeRequest()
    }
}

