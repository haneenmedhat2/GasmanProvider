//
//  WalletPopup.swift
//  Cleaf
//
//  Created by Haneen on 14/05/2025.
//

import UIKit
import Combine

class WalletPopup: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var amountTextField: UITextField!
    //MARK: - Properties -
    
    var viewModel : WalletPopupVM
    var delegate : WalletPopupDelegate?

    //MARK: - Initializer  -
    
    init(viewModel : WalletPopupVM) {
        self.viewModel = viewModel
        super.init(nibName: "WalletPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    //MARK: - View Configuration -
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
           backView.isUserInteractionEnabled = true
           backView.addGestureRecognizer(tapGesture)
    }
    
    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        self.dismiss(animated: false) {
            completion?()
        }
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$validationError
            .compactMap { $0 }
            .sinkOnMain { [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Actions -
        
    @IBAction func didTapConfirm(_ sender: UIButton) {
        validateAmount()
    }
    
    @objc private func backViewTapped() {
        hide()
    }
    
    //MARK: - Validation -

    func validateAmount() {
        let amountText = amountTextField.text
        let isValidated = viewModel.validateWalletAmount(amount: amountText)
    
        if isValidated {
            hide()
            delegate?.didTapOnChargeButton(amount: viewModel.validatedAmount)
        }
    }
}

//MARK: - WalletPopup Delegate Protocol -

protocol WalletPopupDelegate: AnyObject {
    func didTapOnChargeButton(amount: Double)
}
