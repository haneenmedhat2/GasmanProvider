//
//  ProviderHomeVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ProviderHomeVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: ProviderHomeVM
    private let refreshController = UIRefreshControl()
    private lazy var headerView: UIView = makeTableHeaderView()

    // MARK: - Initializer -

    init(viewModel: ProviderHomeVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderHomeVC", bundle: nil)
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
        view.isHidden = true
        setupNotificationButton()
        setupLeftBarButton()
        configureTableView()
        bindViewModel()
        viewModel.resetAndFetch()
        showTutorialIfNeeded()
    }

    private func showTutorialIfNeeded() {
        guard Session.provider?.isSeenTutorialVideo == false else { return }
        viewModel.fetchTutorialVideo()
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$delegates
            .sinkOnMain { [weak self] items in
                guard let self else { return }
                view.isHidden = false
                refreshController.endRefreshing()
                tableView.tableHeaderView = items.isEmpty ? nil : headerView
                tableView.reloadData()
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
                guard let tabBar = self?.tabBarController as? ProviderTabBarController else { return }
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

    @objc private func refreshData() {
        viewModel.resetAndFetch()
    }
}

// MARK: - TableView -

extension ProviderHomeVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.register(cellType: ProviderDelegateCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = nil

        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshController
    }

    private func makeTableHeaderView() -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60))
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "your_affiliated_delegates".localized
        label.font = .myMediumFont(ofSize: 20)
        label.textColor = .black
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16)
        ])
        return container
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.delegates.isEmpty , separator: .none, style: .emptyRelatedDelegates)
        return viewModel.delegates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProviderDelegateCell.self, for: indexPath)
        cell.setupCell(item: viewModel.delegates[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.delegates.count - 1, !viewModel.isLastPage {
            viewModel.fetchNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.delegates[indexPath.row]
        guard let id = item.id else { return }
        let vc = DelegateInfoVC(viewModel: DelegateInfoVM(delegateId: id, initialItem: item))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
