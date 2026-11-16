//
//  InsuranceVC.swift
//  GasmanProvider
//

import UIKit
import Combine
import SDWebImage

class InsuranceVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var metalPriceLabel: UILabel!
    @IBOutlet weak var fiberPriceLabel: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var pricingContainer: UIView!
    @IBOutlet weak var headerRow: UIStackView!
    // MARK: - Properties -

    var viewModel: InsuranceVM

    // MARK: - Initializer -

    init(viewModel: InsuranceVM) {
        self.viewModel = viewModel
        super.init(nibName: "InsuranceVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        self.title = "insurance".localized
        bindViewModel()
        viewModel.getInsurance()
        if let url = Bundle.main.url(forResource: "Wallet", withExtension: "gif") {
            gifImageView.sd_setImage(with: url)
        }
        
        pricingContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        headerRow.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$insurance
            .compactMap { $0 }
            .sinkOnMain { [weak self] insurance in
                guard let self else { return }
                populateUI(with: insurance)
            }
            .store(in: &cancellables)

        viewModel.$chargeResult
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                showSuccessPopup(title: result.message)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    private func populateUI(with insurance: InsuranceResponse) {
        balanceLabel.text = insurance.balance

        let metal = insurance.possibleAndActualCylinders?.metalCylinders
        let fiber = insurance.possibleAndActualCylinders?.fiberCylinders

        let metalPrice = metal?.insurancePrice ?? "0"
        metalPriceLabel.text = metalPrice.toPrice

        let fiberPrice = fiber?.insurancePrice ?? "0"
        fiberPriceLabel.text = fiberPrice.toPrice
    }

    // MARK: - Actions -

    @IBAction func didTapChargeInsurance(_ sender: UIButton) {
        goToChargeInsurance()
    }

    @IBAction func didTapWithdrawInsurance(_ sender: UIButton) {
        goToWithdrawInsurance()
    }
}

// MARK: - Routes -

extension InsuranceVC {

    func goToChargeInsurance() {
        let popup = ChargeInsurancePopup()
        popup.delegate = self
        popup.appear(sender: self)
    }

    func goToWithdrawInsurance() {
        let walletPop = WalletWithdrawalPopup(viewModel: WalletWithdrawalVM(), type: 1)
        walletPop.delegate = self
        walletPop.appear(sender: self)
    }

    func showChargeConfirmation(metalQty: Int, fiberQty: Int) {
        let total = computeChargeTotal(metalQty: metalQty, fiberQty: fiberQty)
        let popup = WithdrawalConfirmationPopup(
            title: "recharge_value".localized,
            amount: formatAmount(total),
            buttonTitle: "recharge".localized
        )
        popup.onConfirm = { [weak self] in
            self?.viewModel.chargeInsurance(metalQty: metalQty, fiberQty: fiberQty)
        }
        popup.appear(sender: self)
    }

    private func computeChargeTotal(metalQty: Int, fiberQty: Int) -> Double {
        let metalPrice = Double(viewModel.insurance?.possibleAndActualCylinders?.metalCylinders?.insurancePrice ?? "0") ?? 0
        let fiberPrice = Double(viewModel.insurance?.possibleAndActualCylinders?.fiberCylinders?.insurancePrice ?? "0") ?? 0
        return Double(metalQty) * metalPrice + Double(fiberQty) * fiberPrice
    }

    private func formatAmount(_ value: Double) -> String {
        return value.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(value))
            : String(format: "%.2f", value)
    }

    func showSuccessPopup(title: String) {
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            self?.viewModel.getInsurance()
        }
    }
}

// MARK: - ChargeInsuranceDelegate -

extension InsuranceVC: ChargeInsuranceDelegate {
    func didConfirmCharge(metalQty: Int, fiberQty: Int) {
        showChargeConfirmation(metalQty: metalQty, fiberQty: fiberQty)
    }
}

// MARK: - WalletWithdrawalProtocol -

extension InsuranceVC: WalletWithdrawalProtocol {
    func didWithdraw(title: String) {
        showSuccessPopup(title: title)
    }
}
