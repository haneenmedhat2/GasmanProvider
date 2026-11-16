//
//  VerificationVC.swift
//  Esterad
//
//  Created by Haneen on 19/10/2025.
//

import UIKit
import Combine

class VerificationVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var verificationView: VerificationView!
    
    //MARK: - Properties -
    
    var viewModel : VerificationVM
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : VerificationVM ){
        self.viewModel = viewModel
        super.init(nibName: "VerificationVC", bundle: nil)
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
        loading(viewModel.$isLoading)
        
        viewModel.$verification
            .dropFirst()
            .sinkOnMain { [weak self] message in
                guard let self = self else { return }
                showPopup(title : message  ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.$remainingTime
            .sinkOnMain{ [weak self] time in
                guard let self = self else { return }
                self.verificationView.updateTimer(time: time)
            }
            .store(in: &cancellables)
        
        viewModel.$validation
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.$isResendEnabled
            .sinkOnMain{ [weak self] isEnabled in
                guard let self = self else { return }
                self.verificationView.setResendEnabled(isEnabled)
            }
            .store(in: &cancellables)
        
        viewModel.$resendCode
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result?.message ?? "")
                viewModel.startCountdown()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }

}

//MARK: - Routes -

extension VerificationVC {
    
    func showPopup(title : String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            popToRoot()
        }
    }
    
    func goToHome() {
        Session.isLogin = true
        let vc: UIViewController = Session.userType == .serviceProvider
            ? ProviderTabBarController.create()
            : AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
}

//MARK: - Delegation -

extension VerificationVC: VerificationViewDelegate {
    
    func didTapConfirm(otp: String) {
         viewModel.validateOTP(otp: otp)
    }
    
    func didTapResend() {
        viewModel.resendCodeRequest()
    }
}

