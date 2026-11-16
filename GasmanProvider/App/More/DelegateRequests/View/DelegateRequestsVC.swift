//
//  DelegateRequestsVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class DelegateRequestsVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: DelegateRequestsVM

    // MARK: - Initializer -

    init(viewModel: DelegateRequestsVM) {
        self.viewModel = viewModel
        super.init(nibName: "DelegateRequestsVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialConfiguration()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        title = "delegate_registration_requests".localized
        configureTableView()
        bindViewModel()
        viewModel.resetAndFetch()
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$requests
            .sinkOnMain { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$actionSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.showPopup(title: result.message)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
    
    private func showPopup(title: String) {
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            self?.pop()
        }
    }
}

// MARK: - TableView -

extension DelegateRequestsVC: UITableViewDataSource, UITableViewDelegate, DelegateRequestCellDelegate {

    private func configureTableView() {
        tableView.register(cellType: DelegateRequestCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.requests.isEmpty , separator: .none, style: .emptyDelegateRequests)
        return viewModel.requests.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DelegateRequestCell.self, for: indexPath)
        cell.delegate = self
        cell.setupCell(item: viewModel.requests[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.requests.count - 1, !viewModel.isLastPage {
            viewModel.fetchNextPage()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = viewModel.requests[indexPath.row].id else { return }
        let vc = DelegateRequestInfoVC(viewModel: DelegateRequestInfoVM(requestId: id))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }

    // MARK: - Cell Delegate -

    func delegateRequestCellDidTapApprove(_ cell: DelegateRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let id = viewModel.requests[indexPath.row].id else { return }
        viewModel.approve(id: id)
    }

    func delegateRequestCellDidTapReject(_ cell: DelegateRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let id = viewModel.requests[indexPath.row].id else { return }
        viewModel.reject(id: id)
    }
}
