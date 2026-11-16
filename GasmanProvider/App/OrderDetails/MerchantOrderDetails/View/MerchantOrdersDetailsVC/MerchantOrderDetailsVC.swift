//
//  MerchantOrderDetailsVC.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import UIKit
import Combine

class MerchantOrderDetailsVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderSummaryView: OrderSummaryView!
    @IBOutlet weak var merchantInfoView: MerchantInfoView!
    @IBOutlet weak var cancelReasonView: LabeledNoteView!
    @IBOutlet weak var deliverToProviderButton: MainButton!
    @IBOutlet weak var finishButton: MainButton!
    @IBOutlet weak var cancelButton: RedButton!

    // MARK: - Properties -

    private let refreshControl = UIRefreshControl()
    let viewModel: MerchantOrderDetailsVM

    // MARK: - Initializer -

    init(viewModel: MerchantOrderDetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: "MerchantOrderDetailsVC", bundle: nil)
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
        viewModel.getOrderDetails()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        self.title = "track_order".localized
        view.isHidden = true
        setupRefreshControl()
        bindViewModel()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }

    @objc private func refreshData() {
        viewModel.getOrderDetails()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$orderDetails
            .compactMap { $0 }
            .sinkOnMain { [weak self] details in
                self?.view.isHidden = false
                self?.refreshControl.endRefreshing()
                self?.populate(with: details)
            }
            .store(in: &cancellables)

        viewModel.$cancelReasons
            .dropFirst()
            .filter { !$0.isEmpty }
            .sinkOnMain { [weak self] reasons in
                self?.showCancelReasonPopup(reasons: reasons)
            }
            .store(in: &cancellables)

        viewModel.$deliverToProviderSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let data = result.data else { return }
                self?.show(successMessage: result.message)
               // self?.populate(with: data)
            }
            .store(in: &cancellables)

        viewModel.$finishSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let data = result.data else { return }
                self?.show(successMessage: result.message)
              //  self?.populate(with: data)
            }
            .store(in: &cancellables)

        viewModel.$cancelSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)
                self?.pop()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Populate -

    private func populate(with details: MerchantOrderDetailsResponse) {
        orderNumberLabel.text = "order_num".localized + (details.orderNum ?? "")
        dateLabel.text = details.date
        timeLabel.text = details.time

        // Order summary
        orderSummaryView.highlightLastRows = false
        orderSummaryView.configure(dataSource: details.getDataSource())

        // Merchant info view
        if let provider = details.provider {
            merchantInfoView.configure(provider: provider)
            merchantInfoView.isHidden = false
        } else {
            merchantInfoView.isHidden = true
        }

        if let reason = details.canceledReason, !reason.isEmpty {
            cancelReasonView.configure(title: "cancel_reason".localized, content: reason)
            cancelReasonView.isHidden = false
        } else {
            cancelReasonView.isHidden = true
        }

        // Actions
        deliverToProviderButton.isHidden = !(details.actions?.deliverToProviderButton ?? false)
        finishButton.isHidden = !(details.actions?.finishButton ?? false)
        cancelButton.isHidden = !(details.actions?.cancelButton ?? false)
    }

    // MARK: - Cancel Flow -

    private func showCancelReasonPopup(reasons: [CancelReasonModel]) {
        let popup = CancelReasonPopup()
        popup.reasonList = reasons
        popup.onCancel = { [weak self] reason in
            self?.viewModel.cancelOrder(reasonId: reason.id ?? 0)
        }
        popup.appear(sender: self)
    }

    // MARK: - Actions -

    @IBAction func didTapDeliverToProvider(_ sender: UIButton) {
        viewModel.deliverToProvider()
    }

    @IBAction func didTapFinish(_ sender: UIButton) {
        viewModel.finishOrder()
    }

    @IBAction func didTapCancel(_ sender: UIButton) {
        viewModel.getCancelReasons()
    }
}
