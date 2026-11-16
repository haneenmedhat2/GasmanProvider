//
//  ForgetPasswordVC.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import UIKit
import Combine

class ForgetPasswordVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var phoneTextField: PhoneTextField!
    
    //MARK: - Properties -
    
    let viewModel : ForgetPasswordVM
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : ForgetPasswordVM){
        self.viewModel = viewModel
        super.init(nibName: "ForgetPasswordVC", bundle: nil)
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
    }
    
    func bindToViewModel(){
        loading(viewModel.$isLoading)
        
        viewModel.$forgetPassword
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result?.message ?? "")
                self.goToVerification()
            }
            .store(in: &cancellables)
        
        viewModel.$validationError
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Action -
    
    @IBAction func didTapConfirms(_ sender: UIButton) {
        let phone = phoneTextField.txtField.text
        viewModel.validatePhone(phone: phone)
    }
}

//MARK: - Routes -

extension ForgetPasswordVC {
    func goToVerification(){
        let phone = phoneTextField.txtField.text ?? ""
        let vc = PasswordVerificationVC(viewModel: PasswordVerificationVM(phone: phone))
        push(vc)
    }
}
