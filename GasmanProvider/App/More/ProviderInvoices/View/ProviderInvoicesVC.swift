//
//  ProviderInvoicesVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ProviderInvoicesVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var customerTabButton: UIButton!
    @IBOutlet weak var commissionTabButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties -

    let viewModel: ProviderInvoicesVM

    // MARK: - Initializer -

    init(viewModel: ProviderInvoicesVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderInvoicesVC", bundle: nil)
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
        title = "invoices".localized
        configureTableView()
        bindViewModel()
        selectTab(.customer)
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$invoices
            .sinkOnMain { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Tabs -

    private func selectTab(_ tab: InvoiceTab) {
        viewModel.selectedTab = tab
        updateTabAppearance(tab)
        viewModel.resetAndFetch()
    }

    private func updateTabAppearance(_ tab: InvoiceTab) {
        let buttons = [customerTabButton, commissionTabButton]
        let selected = tab == .customer ? customerTabButton : commissionTabButton
        buttons.forEach {
            $0?.backgroundColor = .white
            $0?.setTitleColor(.hint, for: .normal)
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.textFieldBorder.cgColor
            $0?.layer.cornerRadius = 12
        }
        selected?.backgroundColor = UIColor(named: "Main")
        selected?.setTitleColor(.white, for: .normal)
        selected?.layer.borderWidth = 0
    }

    // MARK: - Actions -

    @IBAction func didTapCustomerTab(_ sender: UIButton) {
        selectTab(.customer)
    }

    @IBAction func didTapCommissionTab(_ sender: UIButton) {
        selectTab(.commission)
    }
}

// MARK: - TableView -

extension ProviderInvoicesVC: UITableViewDelegate, UITableViewDataSource, InvoiceCellDelegate {

    private func configureTableView() {
        tableView.register(cellType: InvoiceCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.invoices.isEmpty , separator: .none, style: .emptyInvoices)
        return  viewModel.invoices.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: InvoiceCell.self, for: indexPath)
        cell.delegate = self
        cell.setupCell(item: viewModel.invoices[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.invoices.count - 1, !viewModel.isLastPage {
            viewModel.fetchNextPage()
        }
    }

    // MARK: - InvoiceCellDelegate -

    func invoiceCellDidTapOpenInvoice(_ cell: InvoiceCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let invoiceId = viewModel.invoices[indexPath.row].id else { return }
        let vc = InvoiceDetailsVC(viewModel: InvoiceDetailsVM(invoiceId: invoiceId))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
