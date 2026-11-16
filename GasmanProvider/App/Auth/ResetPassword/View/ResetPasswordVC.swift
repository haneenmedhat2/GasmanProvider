//
//  ResetPasswordVC.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import UIKit
import Combine

class ResetPasswordVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    
    //MARK: - Properties -
    
    let viewModel : ResetPasswordVM
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : ResetPasswordVM){
        self.viewModel = viewModel
        super.init(nibName: "ResetPasswordVC", bundle: nil)
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
        bindToViewModel()
        
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeAll { $0 is VerificationVC }
        navigationController?.viewControllers = viewControllers
    }
    
    func bindToViewModel(){
        loading(viewModel.$isLoading)
        
        viewModel.$resetPassword
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                showPopup(title : "password_changed_successfully".localized)
            }
            .store(in: &cancellables)
        
        viewModel.$validation
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        let password = passwordTextField.txtField.text
        let confirmPassword = confirmPasswordTextField.txtField.text
        viewModel.validateUserData(password: password, confirmPassword: confirmPassword)
    }
}

//MARK: - Routes -

extension ResetPasswordVC {
    
    func showPopup(title : String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            popToRoot()
        }
    }
}
