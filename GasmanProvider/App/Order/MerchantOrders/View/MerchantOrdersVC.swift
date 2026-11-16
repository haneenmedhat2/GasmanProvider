//
//  MerchantOrdersVC.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import UIKit
import Combine

class MerchantOrdersVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var orderStateView: OrderStateView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: MerchantOrdersVM
    private let refreshControl = UIRefreshControl()

    // MARK: - Initializer -

    init(viewModel: MerchantOrdersVM) {
        self.viewModel = viewModel
        super.init(nibName: "MerchantOrdersVC", bundle: nil)
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
        self.title = "merchant_orders".localized
        bindViewModel()
        configureTableView()
        configureOrderStateView()
        configureOrderTypeButtons()
        setupRefreshControl()
        viewModel.getOrders()
    }

    private func configureOrderTypeButtons() {
        updateOrderTypeSelection()
    }

    private func configureOrderStateView() {
        orderStateView.delegate = self
        orderStateView.getCollectionViewDataSource(collectionArray: viewModel.statusList)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: - Order Type Selection -

    private func updateOrderTypeSelection() {
        let isReceive = viewModel.orderType == .receive

        receiveButton.backgroundColor = isReceive ? .main : .systemBackground
        receiveButton.setTitleColor(isReceive ? .white : .hint, for: .normal)
        receiveButton.layer.borderWidth = isReceive ? 0 : 1
        receiveButton.layer.borderColor = isReceive ? UIColor.clear.cgColor : UIColor.textFieldBorder.cgColor

        returnButton.backgroundColor = !isReceive ? .main : .systemBackground
        returnButton.setTitleColor(!isReceive ? .white : .hint, for: .normal)
        returnButton.layer.borderWidth = !isReceive ? 0 : 1
        returnButton.layer.borderColor = !isReceive ? UIColor.clear.cgColor : UIColor.textFieldBorder.cgColor
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$orders
            .sinkOnMain { [weak self] _ in
                guard let self else { return }
                refreshControl.endRefreshing()
                tableView.reloadData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapReceive(_ sender: UIButton) {
        guard viewModel.orderType != .receive else { return }
        viewModel.orderType = .receive
        updateOrderTypeSelection()
        viewModel.resetData()
        viewModel.getOrders()
    }

    @IBAction func didTapReturn(_ sender: UIButton) {
        guard viewModel.orderType != .return else { return }
        viewModel.orderType = .return
        updateOrderTypeSelection()
        viewModel.resetData()
        viewModel.getOrders()
    }

    @objc private func refreshData() {
        viewModel.resetData()
        viewModel.getOrders()
    }
}

// MARK: - TableView -

extension MerchantOrdersVC: UITableViewDelegate, UITableViewDataSource {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: MerchantOrderCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.ordersList.isEmpty, separator: .none, style: .emptyOrder)
        return viewModel.ordersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MerchantOrderCell.self, for: indexPath)
        cell.setupCell(model: viewModel.ordersList[indexPath.row], orderStatus: viewModel.status)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let item = viewModel.ordersList[indexPath.row]
        goToOrderDetails(orderId : item.id ?? 0)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.ordersList.count - 1, !viewModel.isLastPage {
            viewModel.getOrders()
        }
    }
}

// MARK: - OrderStateViewDelegate -

extension MerchantOrdersVC: OrderStateViewDelegate {
    func didSelectItem(at orderStatus: OrderStatus) {
        viewModel.status = orderStatus
        viewModel.resetData()
        viewModel.getOrders()
    }
}

//MARK: - Routes -

extension MerchantOrdersVC {
    func goToOrderDetails(orderId : Int) {
        let vc = MerchantOrderDetailsVC(viewModel: MerchantOrderDetailsVM(orderId: orderId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
