//
//  ClientOrderDetailsVC.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

import UIKit
import Combine

class ClientOrderDetailsVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusBarView: OrderStatusBarView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var orderSummaryView: OrderSummaryView!
    @IBOutlet weak var clientNotesView: LabeledNoteView!
    @IBOutlet weak var cancelReasonView: LabeledNoteView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var clientInfoView: ClientInfoView!

    // On My Way
    @IBOutlet weak var onMyWayButton: MainButton!
    
    // Deliver To Customer
    @IBOutlet weak var deliverToCustomerButton: MainButton!

    // Accept / Refuse
    @IBOutlet weak var acceptRefuseStackView: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var refuseButton: UIButton!

    //MARK: - Properties -

    private let refreshControl = UIRefreshControl()
    let viewModel: ClientOrderDetailsVM

    //MARK: - Initializer -

    init(viewModel: ClientOrderDetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: "ClientOrderDetailsVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getOrderDetails()
    }

    //MARK: - Setup -

    func initialConfiguration() {
        self.title = "track_order".localized
        view.isHidden = true
        configureTableView()
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

    //MARK: - ViewModel Binding -

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

        viewModel.$acceptSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let data = result.data else { return }
                self?.show(successMessage: result.message)
                self?.populate(with: data)
            }
            .store(in: &cancellables)

        viewModel.$refuseSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)
                self?.popToRoot()
            }
            .store(in: &cancellables)

        viewModel.$onMyWaySuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let data = result.data else { return }
                self?.show(successMessage: result.message)
                self?.populate(with: data)
            }
            .store(in: &cancellables)

        viewModel.$deliverSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let data = result.data else { return }
                self?.show(successMessage: result.message)
                self?.populate(with: data)
            }
            .store(in: &cancellables)

        viewModel.$rateClientSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    //MARK: - Populate -

    private func populate(with details: OrderDetails) {
        orderNumberLabel.text = "order_num".localized + (details.orderNum ?? "")
        dateLabel.text = details.date
        timeLabel.text = details.time

        statusBarView.configure(currentStep: details.status?.key ?? 0, title: details.status?.title)
        tableView.reloadData()
        orderSummaryView.configure(dataSource: details.financials?.getDataSource() ?? [])

        let showAccept  = details.actions?.acceptButton ?? false
        let showRefuse  = details.actions?.refuseButton ?? false
        let showRate    = details.actions?.rateClientButton ?? false
        let showTrack   = details.actions?.onWayButton ?? false
        let showDeliver = details.actions?.deliverToCustomerButton ?? false

        acceptRefuseStackView.isHidden = !showAccept && !showRefuse
        acceptButton.isHidden = !showAccept
        refuseButton.isHidden = !showRefuse

        rateButton.isHidden = !showRate
        trackButton.isHidden = details.isTrackButtonHidden
        onMyWayButton.isHidden = !showTrack
        deliverToCustomerButton.isHidden = !showDeliver

        let isCash = details.financials?.payTypeObj?.name == "cash"
        let deliverTitle = (isCash ? "paid" : "deliver_to_customer").localized
        deliverToCustomerButton.setTitle(deliverTitle, for: .normal)
        
        if let userRate = details.userRates?.first {
            ratingView.configure(userRate: userRate)
            ratingView.isHidden = false
        } else if let clientRate = details.clientRate {
            ratingView.configure(myRate: clientRate)
            ratingView.isHidden = false
        } else {
            ratingView.isHidden = !(details.isRatedDelegate ?? false)
        }
        statusBarView.isHidden = details.isStatusBarHidden

        // Client info
        if let user = details.user {
            clientInfoView.configure(client: user, phone: details.userPhone)
            clientInfoView.isHidden = false
        } else {
            clientInfoView.isHidden = true
        }

        if let notes = details.notes {
            clientNotesView.configure(title: "customer_notes".localized, content: notes)
            clientNotesView.isHidden = false
        } else {
            clientNotesView.isHidden = true
        }
    }

    //MARK: - Rate Client Flow -

    private func showRateClientPopup() {
        let popup = RateClientPopup()
        popup.orderId = viewModel.orderId
        popup.client = viewModel.orderDetails?.user
        popup.onConfirm = { [weak self] model in
            self?.viewModel.rateClient(model: model)
        }
        popup.appear(sender: self)
    }

    //MARK: - Actions -

    @IBAction func didTapTrack(_ sender: UIButton) {
    }

    @IBAction func didTapOnMyWay(_ sender: UIButton) {
        viewModel.onMyWay()
    }

    @IBAction func didTapDeliverToCustomer(_ sender: UIButton) {
        viewModel.deliverToCustomer()
    }

    @IBAction func didTapRate(_ sender: UIButton) {
        showRateClientPopup()
    }

    @IBAction func didTapAccept(_ sender: UIButton) {
        viewModel.acceptOrder()
    }

    @IBAction func didTapRefuse(_ sender: UIButton) {
        viewModel.refuseOrder()
    }
}

//MARK: - TableView -

extension ClientOrderDetailsVC: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate   = self
        tableView.register(cellType: ProductCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orderDetails?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductCell.self, for: indexPath)
        if let item = viewModel.orderDetails?.items?[indexPath.row] {
            cell.setupCell(orderItem: item)
        }
        return cell
    }
}
