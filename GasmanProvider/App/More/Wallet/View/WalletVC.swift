//
//  WalletVC.swift
//  Esterad
//
//  Created by Haneen on 05/11/2025.
//

import UIKit
import Combine
import SDWebImage

class WalletVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    
    //MARK: - Properties -
    
    let viewModel : WalletVM
    
    //MARK: - Initializer -
    
    init(viewModel : WalletVM){
        self.viewModel = viewModel
        super.init(nibName: "WalletVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.showWalletRequest()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration() {
        self.title = "wallet".localized
        bindViewModel()
        if let url = Bundle.main.url(forResource: "Wallet", withExtension: "gif") {
            gifImageView.sd_setImage(with: url)
        }
    }
    
    //MARK: - ViewModel Binding -

    private func bindViewModel() {
        
        loading(viewModel.$isLoading)
        
        viewModel.$showWallet
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.balanceLabel.text = result?.data?.balance 
            }
            .store(in: &cancellables)
        
        viewModel.$chargeWallet
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showPopup(title: result.message)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapWalletRecharge(_ sender: UIButton) {
        goToWalletRecharge()
    }
    
    @IBAction func didTapWalletWithdrawal(_ sender: UIButton) {
        goToWalletWithdraw()
    }
}

//MARK: - Routes -

extension WalletVC {
        
    func goToWalletRecharge() {
        let walletPop = WalletPopup(viewModel: WalletPopupVM())
        walletPop.delegate = self
        walletPop.appear(sender: self)
    }
    
    func goToWalletWithdraw() {
        let walletPop = WalletWithdrawalPopup(viewModel: WalletWithdrawalVM())
        walletPop.delegate = self
        walletPop.appear(sender: self)
    }
    
    func showPopup(title : String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
    }
}

//MARK: - WalletPopup Delegation -

extension WalletVC : WalletPopupDelegate , WalletWithdrawalProtocol {
    func didWithdraw(title: String) {
        showPopup(title: title)
        viewModel.showWalletRequest()
    }
    
    func didTapOnChargeButton(amount: Double) {
        viewModel.chargeWalletRequest(amount: amount)
    }
}
