//
//  WalletWithdrawalPopup.swift
//  GasMan
//
//  Created by Haneen on 10/02/2026.
//

import UIKit
import Combine

class WalletWithdrawalPopup: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var withdrawAmountTextField: UITextField!
    @IBOutlet weak var banknameTextField: UITextField!
    @IBOutlet weak var accountNumTextField: UITextField!
    @IBOutlet weak var ibanTextField: UITextField!
    
    //MARK: - Properties -
    
    var viewModel : WalletWithdrawalVM
    var delegate : WalletWithdrawalProtocol?
    private let type: Int

    //MARK: - Initializer  -

    init(viewModel: WalletWithdrawalVM, type: Int = 0) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: "WalletWithdrawalPopup", bundle: nil)
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
    
    func hide(isDelegateCalled : Bool = false , message : String = ""){
        self.dismiss(animated: false) { [weak self] in
            guard let self = self else { return }
            if isDelegateCalled {
                self.delegate?.didWithdraw(title: message)
            }

        }
    }
    
    //MARK: - ViewModel binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$validation
            .compactMap { $0 }
            .sinkOnMain { [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.$withdrawalAmount
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.hide(isDelegateCalled: true , message: result.message)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        viewModel.validateData(model: WithdrawMoney(amount: withdrawAmountTextField.text, bankName: banknameTextField.text, bankAccountNumber: accountNumTextField.text, iban: ibanTextField.text, type: type))
    }
    
    @objc private func backViewTapped() {
        hide()
    }
}

//MARK: - Protocol -

protocol WalletWithdrawalProtocol {
    func didWithdraw(title : String)
}

