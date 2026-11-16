//
//  ClientOrdersVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ClientOrdersVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var orderStateView: OrderStateView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    var viewModel: ClientOrdersVM
    private let refreshControl = UIRefreshControl()

    // MARK: - Initializer -

    init(viewModel: ClientOrdersVM) {
        self.viewModel = viewModel
        super.init(nibName: "ClientOrdersVC", bundle: nil)
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
        self.title = "client_orders".localized
        bindViewModel()
        configureTableView()
        configureOrderStateView()
        setupRefreshControl()
        viewModel.getOrders()
    }

    private func configureOrderStateView() {
        orderStateView.delegate = self
        orderStateView.getCollectionViewDataSource(collectionArray: viewModel.clientStatusList)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
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

        viewModel.$acceptSuccess
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                show(successMessage: result?.message ?? "")
                viewModel.resetData()
                viewModel.getOrders()
            }
            .store(in: &cancellables)
        
        viewModel.$refuseSuccess
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                show(successMessage: result?.message ?? "")
                viewModel.resetData()
                viewModel.getOrders()
            }
            .store(in: &cancellables)


        error(viewModel.$error)
    }

    // MARK: - Actions -

    @objc private func refreshData() {
        viewModel.resetData()
        viewModel.getOrders()
    }
}

// MARK: - TableView -

extension ClientOrdersVC: UITableViewDelegate, UITableViewDataSource {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: ClientOrderCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.ordersList.isEmpty, separator: .none, style: .emptyOrder)
        return viewModel.ordersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ClientOrderCell.self, for: indexPath)
        cell.setupCell(model: viewModel.ordersList[indexPath.row], orderStatus: viewModel.status)
        cell.delegate = self
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

extension ClientOrdersVC: OrderStateViewDelegate {
    func didSelectItem(at orderStatus: OrderStatus) {
        viewModel.status = orderStatus
        viewModel.resetData()
        viewModel.getOrders()
    }
}

// MARK: - ClientOrderCellDelegate -

extension ClientOrdersVC: ClientOrderCellDelegate {
    func didTapAccept(orderId: Int) {
        viewModel.acceptOrder(id: orderId)
    }

    func didTapReject(orderId: Int) {
        viewModel.rejectOrder(id: orderId)
    }

    func didTapViewMore(orderId: Int) {
        goToOrderDetails(orderId : orderId)
    }
}

//MARK: - Routes -

extension ClientOrdersVC {
    func goToOrderDetails(orderId : Int) {
        let vc = ClientOrderDetailsVC(viewModel: ClientOrderDetailsVM(orderId: orderId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
