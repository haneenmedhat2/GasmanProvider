//
//  OrderTypeVC.swift
//  GasmanProvider
//
//  Created by Haneen on 24/03/2026.
//

import UIKit
import Combine

class OrderTypeVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: TableViewContentSized!

    // MARK: - Properties -

    var viewModel : OrderTypeVM
    
    // MARK: - Initializer -

    init(viewModel : OrderTypeVM) {
        self.viewModel = viewModel
        super.init(nibName: "OrderTypeVC", bundle: nil)
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
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        setupNotificationButton()
        setupLeftBarButton()
        configureTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
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
}

// MARK: - UITableView -

extension OrderTypeVC: UITableViewDataSource, UITableViewDelegate {
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: OrderTypeCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrderTypeCell.self, for: indexPath)
        let item = viewModel.orderTypeList[indexPath.row]
        cell.setupCell(title: item.name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.orderTypeList[indexPath.row]
        switch item.id {
        case 1:
            let vc = ClientOrdersVC(viewModel: ClientOrdersVM())
            vc.hidesBottomBarWhenPushed = true
            push(vc)
        case 2:
            let vc = MerchantOrdersVC(viewModel: MerchantOrdersVM())
            vc.hidesBottomBarWhenPushed = true
            push(vc)
        default:
            break
        }
    }
}
