//
//  HomeVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class HomeVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var availableForOrdersContainer: UIView!
    @IBOutlet weak var availableForOrdersLabel: UILabel!
    @IBOutlet weak var availableForOrdersSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: HomeVM
    let refreshController = UIRefreshControl()

    // MARK: - Initializer -

    init(viewModel: HomeVM) {
        self.viewModel = viewModel
        super.init(nibName: "HomeVC", bundle: nil)
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
        viewModel.getHomeData()
        configureAvailableForOrders()
    }

    // MARK: - Setup -


    private func initialConfiguration() {
        setupNotificationButton()
        setupLeftBarButton()
        configureTableView()
        bindViewModel()
        showTutorialIfNeeded()
    }

    private func showTutorialIfNeeded() {
        guard Session.user?.isSeenTutorialVideo == false else { return }
        viewModel.fetchTutorialVideo()
    }

    private func configureAvailableForOrders() {
        availableForOrdersSwitch.isOn = Session.user?.canOrder ?? false
        availableForOrdersSwitch.addTarget(self, action: #selector(didToggleAvailable), for: .valueChanged)
    }

    private var pendingReceiveToggle = false

    @objc private func didToggleAvailable() {
        pendingReceiveToggle = true
        viewModel.switchReceiveOrders()
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$home
            .sinkOnMain { [weak self] _ in
                guard let self else { return }
                refreshController.endRefreshing()
                tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$acceptSuccess
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                show(successMessage: result?.message ?? "")
                viewModel.resetData()
                viewModel.getHomeData()
            }
            .store(in: &cancellables)
        
        viewModel.$refuseSuccess
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                show(successMessage: result?.message ?? "")
                viewModel.resetData()
                viewModel.getHomeData()
            }
            .store(in: &cancellables)

        viewModel.$receiveOrder
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                pendingReceiveToggle = false
                let canOrder = result?.data ?? (Session.user?.canOrder ?? false)
                availableForOrdersSwitch.setOn(canOrder, animated: true)
                show(successMessage: result?.message ?? "")
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                guard let self, pendingReceiveToggle else { return }
                pendingReceiveToggle = false
                availableForOrdersSwitch.setOn(Session.user?.canOrder ?? false, animated: true)
            }
            .store(in: &cancellables)

        viewModel.$tutorialVideo
            .compactMap { $0 }
            .sinkOnMain { [weak self] data in
                self?.presentTutorialPopup(data: data)
            }
            .store(in: &cancellables)
        
        viewModel.$notificationCount
            .sinkOnMain { [weak self] count in
                self?.updateNotificationCount(count ?? 0)
            }
            .store(in: &cancellables)
        
        viewModel.$newOrdersCount
            .sinkOnMain { [weak self] count in
                guard let tabBar = self?.tabBarController as? AppTabBarController else { return }
                tabBar.updateOrdersBadge(count: count ?? 0)
            }
            .store(in: &cancellables)


        error(viewModel.$error)
    }

    private func presentTutorialPopup(data: TutorialVideoModel) {
        guard let urlString = data.tutorialVideo, let url = URL(string: urlString) else { return }
        let title = (data.title?.trimWhiteSpace().isEmpty == false) ? data.title! : "delegate_tutorial_video".localized
        let popup = TutorialVideoPopup(videoURL: url, title: title)
        popup.onClose = { [weak self] in
            self?.viewModel.markTutorialSeen()
        }
        popup.appear(sender: self)
    }

    // MARK: - Actions -

    @objc private func refreshData() {
        viewModel.resetData()
        viewModel.getHomeData()
    }
}

// MARK: - TableView -

extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: ClientOrderCell.self)

        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshController
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.ordersList.isEmpty, separator: .none, style: .emptyOrder)
        return viewModel.ordersList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.ordersList[indexPath.row]
        let cell = tableView.dequeueReusableCell(with: ClientOrderCell.self, for: indexPath)
        cell.setupCell(model: item, orderStatus: .new)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.ordersList.count - 1, !viewModel.isLastPage {
            viewModel.getHomeData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.ordersList[indexPath.row]
        goToOrderDetails(orderId: item.id ?? 0)
    }
}

// MARK: - ClientOrderCellDelegate -

extension HomeVC: ClientOrderCellDelegate {
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

extension HomeVC {
    func goToOrderDetails(orderId : Int) {
        let vc = ClientOrderDetailsVC(viewModel: ClientOrderDetailsVM(orderId: orderId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
