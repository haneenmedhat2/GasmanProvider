//
//  StockTrackingVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class StockTrackingVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerMsgLabel: UILabel!
    @IBOutlet weak var bannerCountLabel: UILabel!
    @IBOutlet weak var bannerMoreButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: TableViewContentSized!

    // MARK: - Properties -

    let viewModel: StockTrackingVM
    private var tableViewHeightConstraint: NSLayoutConstraint?

    // MARK: - Initializer -

    init(viewModel: StockTrackingVM) {
        self.viewModel = viewModel
        super.init(nibName: "StockTrackingVC", bundle: nil)
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
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        view.isHidden = true
        setupNotificationButton()
        setupLeftBarButton()
        setupBannerMoreButton()
        configureTableView()
        bindViewModel()
        viewModel.fetchSummary()
    }

    private func setupBannerMoreButton() {
        let underlineAttr: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        bannerMoreButton.setAttributedTitle(
            NSAttributedString(string: "more".localized, attributes: underlineAttr),
            for: .normal
        )
    }
    
    //MARK: - Actions -
    
    @IBAction func didTapMore(_ sender: UIButton) {
        let vc = DelegatesOverdueVC(viewModel: DelegatesOverdueVM())
        push(vc)
    }
    
    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$summary
            .dropFirst()
            .sinkOnMain { [weak self] summary in
                self?.updateBanner(summary: summary)
                self?.tableView.reloadData()
                self?.view.isHidden = false
            }
            .store(in: &cancellables)
        
        viewModel.$notificationCount
            .sinkOnMain { [weak self] count in
                self?.updateNotificationCount(count ?? 0)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    private func updateBanner(summary: StockTrackingSummaryModel?) {
        guard let summary else { return }
        let count = summary.overdueCylindersCount ?? 0
        bannerView.isHidden = count == 0
        titleLabel.isHidden = count == 0
        bannerMsgLabel.text = summary.msg
        let cylinderWord = summary.cylinder ?? ""
        bannerCountLabel.text = "\(count) \(cylinderWord)"
    }
}

// MARK: - UITableView -

extension StockTrackingVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: StockTrackingCylinderCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.summary?.overdueCylindersCount ?? 0
        let isEmpty = count == 0
        tableView.setPlaceholder(isEmpty: isEmpty, separator: .none ,style: .emptyStockTracking)

        if isEmpty {
            if tableViewHeightConstraint == nil {
                tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 300)
            }
            tableViewHeightConstraint?.isActive = true
            return 0
        } else {
            tableViewHeightConstraint?.isActive = false
            return viewModel.summary?.cylindersList.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: StockTrackingCylinderCell.self, for: indexPath)
        if let cylinder = viewModel.summary?.cylindersList[indexPath.row] {
            cell.configure(with: cylinder)
        }
        return cell
    }
}
