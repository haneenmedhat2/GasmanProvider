//
//  SettlementVC.swift
//  GasmanProvider
//

import UIKit
import Combine
import SDWebImage

class SettlementVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var walletImageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    // MARK: - Properties -

    let viewModel: SettlementVM

    // MARK: - Initializer -

    init(viewModel: SettlementVM) {
        self.viewModel = viewModel
        super.init(nibName: "SettlementVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchSettlementCashReceived()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        title = "settlement".localized
        labelTitle.text = "settlement_cash_received_label".localized
        if let url = Bundle.main.url(forResource: "Wallet", withExtension: "gif") {
            walletImageView.sd_setImage(with: url)
        }
        bindViewModel()
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$settlement
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.amountLabel.text = result.totalCashReceived ?? "0"
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
}
