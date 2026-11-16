//
//  ProviderOrdersVC.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import UIKit
import Combine

class ProviderOrdersVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var orderStateView: OrderStateView!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: ProviderOrdersVM
    private let refreshControl = UIRefreshControl()

    // MARK: - Initializer -

    init(viewModel: ProviderOrdersVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderOrdersVC", bundle: nil)
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
        super.viewWillAppear(true)
        viewModel.getNotificationCount()
        viewModel.getOrdersCount()
        viewModel.getOrders()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        setupNotificationButton()
        setupLeftBarButton()
        bindViewModel()
        configureTableView()
        configureOrderStateView()
        configureOrderTypeButtons()
        setupRefreshControl()
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
        
        viewModel.$notificationCount
            .sinkOnMain { [weak self] count in
                self?.updateNotificationCount(count ?? 0)
            }
            .store(in: &cancellables)

        viewModel.$newOrdersCount
            .sinkOnMain { [weak self] count in
                guard let tabBar = self?.tabBarController as? ProviderTabBarController else { return }
                tabBar.updateOrdersBadge(count: count ?? 0)
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

extension ProviderOrdersVC: UITableViewDelegate, UITableViewDataSource {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: ProviderOrderCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.ordersList.isEmpty, separator: .none, style: .emptyOrder)
        return viewModel.ordersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProviderOrderCell.self, for: indexPath)
        let item = viewModel.ordersList[indexPath.row]
        cell.setupCell(model: item, orderStatus: viewModel.status)
        cell.onAccept = { [weak self] in
            self?.goToOrderDetails(orderId: item.id ?? 0)
        }
        cell.onReject = { [weak self] in
            self?.goToOrderDetails(orderId: item.id ?? 0)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.ordersList[indexPath.row]
        goToOrderDetails(orderId: item.id ?? 0)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.ordersList.count - 1, !viewModel.isLastPage {
            viewModel.getOrders()
        }
    }
}

// MARK: - OrderStateViewDelegate -

extension ProviderOrdersVC: OrderStateViewDelegate {
    func didSelectItem(at orderStatus: OrderStatus) {
        viewModel.status = orderStatus
        viewModel.resetData()
        viewModel.getOrders()
    }
}

// MARK: - Routes -

extension ProviderOrdersVC {
    func goToOrderDetails(orderId: Int) {
        let vc = ProviderOrderDetailsVC(viewModel: ProviderOrderDetailsVM(orderId: orderId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
