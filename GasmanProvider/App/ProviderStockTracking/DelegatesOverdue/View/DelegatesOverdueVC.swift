//
//  DelegatesOverdueVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class DelegatesOverdueVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: DelegatesOverdueVM
    let refreshController = UIRefreshControl()

    // MARK: - Initializer -

    init(viewModel: DelegatesOverdueVM) {
        self.viewModel = viewModel
        super.init(nibName: "DelegatesOverdueVC", bundle: nil)
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
        self.title = "track".localized
        configureTableView()
        setupRefreshControl()
        bindViewModel()
        viewModel.getDelegatesOverdue()
    }

    private func setupRefreshControl() {
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshController
    }

    // MARK: - Actions -

    @objc private func refreshData() {
        viewModel.resetData()
        viewModel.getDelegatesOverdue()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$response
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                guard let self else { return }
                self.refreshController.endRefreshing()
                self.tableView.reloadData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
}

// MARK: - UITableView -

extension DelegatesOverdueVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: DelegateOverdueCell.self)
        tableView.separatorStyle = .none
        setupTableHeaderView()
    }

    private func setupTableHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let titleLabel = UILabel()
        titleLabel.text = "stock_tracking".localized
        titleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .natural
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: 0),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        tableView.tableHeaderView = headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.delegatesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DelegateOverdueCell.self, for: indexPath)
        let delegate = viewModel.delegatesList[indexPath.row]
        cell.configure(with: delegate)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.delegatesList.count - 1,
           !viewModel.isLastPage {
            viewModel.getDelegatesOverdue()
        }
    }
}
