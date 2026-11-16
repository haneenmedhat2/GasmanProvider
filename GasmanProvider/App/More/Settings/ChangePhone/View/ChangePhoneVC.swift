//
//  ChangePhoneVC.swift
//  Esterad
//
//  Created by Haneen on 04/11/2025.
//

import UIKit
import Combine

class ChangePhoneVC: BaseViewController {
    
    //MARK: - Outlets -

    @IBOutlet weak var phoneTextField: PhoneTextField!
    
    //MARK: - Properties -
    
    let viewModel : ChangePhoneVM
    
    //MARK: - Initializer -
    
    init(viewModel : ChangePhoneVM){
        self.viewModel = viewModel
        super.init(nibName: "ChangePhoneVC", bundle: nil)
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
        self.title = "phone_number".localized
        bindToViewModel()
        
        guard var viewControllers = navigationController?.viewControllers else { return }
        viewControllers.removeAll { $0 is ChangePhoneVerifyVC }
        navigationController?.viewControllers = viewControllers
    }
    
    //MARK: -  Binding To ViewModel -
    
    func bindToViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$changePhone
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                self.goToVerification()
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
    
    @IBAction func didTapChange(_ sender: UIButton) {
         let phone = phoneTextField.txtField.text
        viewModel.validatePhone(phone: phone)
    }
}

//MARK: - Routes -

extension ChangePhoneVC {
    func goToVerification(){
        guard let phone = phoneTextField.txtField.text else { return }
        let vc = ChangePhoneVerifyVC(viewModel: ChangePhoneVerifyVM(mode: .newPhone, phone: phone))
        push(vc)
    }
}
