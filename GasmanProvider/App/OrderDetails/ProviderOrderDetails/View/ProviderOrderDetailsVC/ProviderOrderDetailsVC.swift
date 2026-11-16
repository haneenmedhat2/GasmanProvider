//
//  ProviderOrderDetailsVC.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import UIKit
import Combine

class ProviderOrderDetailsVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var orderSummaryView: OrderSummaryView!
    @IBOutlet weak var delegateInfoView: DelegateInfoView!
    @IBOutlet weak var cancelReasonView: LabeledNoteView!
    @IBOutlet weak var acceptButton: MainButton!
    @IBOutlet weak var finishButton: MainButton!
    @IBOutlet weak var refuseButton: RedButton!
    @IBOutlet weak var acceptRejectStackView: UIStackView!
    
    // MARK: - Properties -

    private let refreshControl = UIRefreshControl()
    let viewModel: ProviderOrderDetailsVM

    // MARK: - Initializer -

    init(viewModel: ProviderOrderDetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderOrderDetailsVC", bundle: nil)
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
        self.title = "track_order".localized
        view.isHidden = true
        setupRefreshControl()
        bindViewModel()
        viewModel.getOrderDetails()
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

        viewModel.$refuseReasons
            .dropFirst()
            .filter { !$0.isEmpty }
            .sinkOnMain { [weak self] reasons in
                self?.showRefuseReasonPopup(reasons: reasons)
            }
            .store(in: &cancellables)

        viewModel.$acceptSuccess
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
               // self?.populate(with: data)
            }
            .store(in: &cancellables)

        viewModel.$refuseSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)
                self?.pop()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Populate -

    private func populate(with details: ProviderOrderDetailsResponse) {
        orderNumberLabel.text = "order_num".localized + (details.orderNum ?? "")
        dateLabel.text = details.date
        timeLabel.text = details.time

        orderSummaryView.highlightLastRows = false
        orderSummaryView.configure(dataSource: details.getDataSource())

        if let delegate = details.delegate {
            delegateInfoView.configure(delegate: delegate)
            delegateInfoView.isHidden = false
        } else {
            delegateInfoView.isHidden = true
        }

        if let reason = details.canceledReason, !reason.isEmpty {
            cancelReasonView.configure(title: "cancel_reason".localized, content: reason)
            cancelReasonView.isHidden = false
        } else {
            cancelReasonView.isHidden = true
        }

        acceptButton.isHidden = !(details.actions?.acceptButton ?? false)
        finishButton.isHidden = !(details.actions?.finishedButton ?? false)
        refuseButton.isHidden = !(details.actions?.refuseButton ?? false)
        acceptRejectStackView.isHidden = !(details.actions?.acceptButton ?? false || details.actions?.refuseButton ?? false)
    }

    // MARK: - Refuse Flow -

    private func showRefuseReasonPopup(reasons: [CancelReasonModel]) {
        let popup = CancelReasonPopup()
        popup.reasonList = reasons
        popup.onCancel = { [weak self] reason in
            self?.viewModel.refuseOrder(reasonId: reason.id ?? 0)
        }
        popup.appear(sender: self)
    }

    // MARK: - Actions -

    @IBAction func didTapAccept(_ sender: UIButton) {
        viewModel.acceptOrder()
    }

    @IBAction func didTapFinish(_ sender: UIButton) {
        viewModel.finishOrder()
    }

    @IBAction func didTapRefuse(_ sender: UIButton) {
        viewModel.getRefuseReasons()
    }
}
