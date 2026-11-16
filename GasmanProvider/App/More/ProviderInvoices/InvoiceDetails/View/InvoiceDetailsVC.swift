//
//  InvoiceDetailsVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class InvoiceDetailsVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var orderSummaryView: OrderSummaryView!
    @IBOutlet weak var clientInfoView: ClientInfoView!
    @IBOutlet weak var openInvoiceButton: UIButton!

    // MARK: - Properties -

    let viewModel: InvoiceDetailsVM

    // MARK: - Initializer -

    init(viewModel: InvoiceDetailsVM) {
        self.viewModel = viewModel
        super.init(nibName: "InvoiceDetailsVC", bundle: nil)
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
        title = "invoice_details".localized
        view.isHidden = true
        configureTableView()
        configureOpenInvoiceButton()
        bindViewModel()
        viewModel.fetchDetails()
    }

    private func configureOpenInvoiceButton() {
        let title = "invoice_for_order".localized
        let attr = NSAttributedString(string: title, attributes: [
            .foregroundColor: UIColor.main,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ])
        openInvoiceButton.setAttributedTitle(attr, for: .normal)
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$details
            .compactMap { $0 }
            .sinkOnMain { [weak self] details in
                self?.view.isHidden = false
                self?.populate(details)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Populate -

    private func populate(_ details: InvoiceDetails) {
        orderNumberLabel.text = "order_num".localized + (details.orderNum ?? "")
        dateLabel.text = details.date
        timeLabel.text = details.time

        tableView.reloadData()
        orderSummaryView.configure(dataSource: details.financials?.getDataSource() ?? [])

        if let user = details.user {
            let client = Client(id: nil, name: user.name, image: user.image, lat: nil, lng: nil, mapDesc: nil)
            clientInfoView.configure(client: client, phone: user.phone)
            clientInfoView.isHidden = false
        } else {
            clientInfoView.isHidden = true
        }

        //openInvoiceButton.isHidden = (details.invoiceURL?.isEmpty ?? true)
    }

    // MARK: - Actions -

    @IBAction func didTapOpenInvoice(_ sender: UIButton) {
        guard let urlString = viewModel.details?.invoiceURL else { return }
        
        let vc = WebViewController()
        vc.urlString = urlString
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)    }
}

// MARK: - TableView -

extension InvoiceDetailsVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.register(cellType: ProductCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.details?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ProductCell.self, for: indexPath)
        if let item = viewModel.details?.items?[indexPath.row] {
            cell.setupCell(orderItem: item)
        }
        return cell
    }
}
