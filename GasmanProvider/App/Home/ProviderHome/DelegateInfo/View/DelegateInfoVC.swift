//
//  DelegateInfoVC.swift
//  GasmanProvider
//

import UIKit
import Combine
import SDWebImage

class DelegateInfoVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var personalTabButton: UIButton!
    @IBOutlet weak var reportsTabButton: UIButton!
    @IBOutlet weak var settlementTabButton: UIButton!

    // Personal
    @IBOutlet weak var personalContainerView: UIView!
    @IBOutlet weak var delegateCardView: UIView!
    @IBOutlet weak var delegateAvatarImageView: UIImageView!
    @IBOutlet weak var delegateNameLabel: UILabel!
    @IBOutlet weak var delegatePhoneLabel: UILabel!
    @IBOutlet weak var delegatePhoneIconView: UIView!
    @IBOutlet weak var storageSwitch: UISwitch!
    @IBOutlet weak var storageToggleLabel: UILabel!

    // Reports
    @IBOutlet weak var reportsContainerView: UIView!
    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    @IBOutlet weak var statsCollectionView: CollectionViewContentSized!

    // Settlement
    @IBOutlet weak var settlementContainerView: UIView!
    @IBOutlet weak var settlementWalletImageView: UIImageView!
    @IBOutlet weak var settlementAmountTitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var settleButton: UIButton!

    // MARK: - Properties -

    let viewModel: DelegateInfoVM

    private var periodButtons: [UIButton] = []
    private var pendingStorageToggle = false

    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    // MARK: - Initializer -

    init(viewModel: DelegateInfoVM) {
        self.viewModel = viewModel
        super.init(nibName: "DelegateInfoVC", bundle: nil)
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
        title = "delegate_info".localized
        periodButtons = [dailyButton, weeklyButton, monthlyButton, yearlyButton]
        configureCardStyle()
        configureSettlementWallet()
        configureCollectionView()
        setupDatePickers()
        bindViewModel()
        renderInfoIfAvailable()
        viewModel.fetchInfo()
        selectTab(.personal)
        selectPeriod(.daily)
    }

    private func configureCardStyle() {
        delegateCardView.layer.cornerRadius = 12
        delegateCardView.layer.borderWidth = 1
        delegateCardView.layer.borderColor = UIColor.textFieldBorder.cgColor
        delegateCardView.clipsToBounds = true
        delegateAvatarImageView.contentMode = .scaleAspectFill
        delegateAvatarImageView.backgroundColor = .textFieldBorder
        delegateAvatarImageView.clipsToBounds = true
        delegateAvatarImageView.layer.cornerRadius = 22
        delegatePhoneIconView.layer.cornerRadius = 12
        delegatePhoneIconView.clipsToBounds = true
    }

    private func configureSettlementWallet() {
        if let url = Bundle.main.url(forResource: "Wallet", withExtension: "gif") {
            settlementWalletImageView.sd_setImage(with: url)
        }
    }

    private func setupDatePickers() {
        for textField in [dateFromTextField, dateToTextField] {
            let picker = UIDatePicker()
            picker.datePickerMode = .date
            picker.locale = Locale(identifier: "en_US_POSIX")
            picker.calendar = Calendar(identifier: .gregorian)
            picker.preferredDatePickerStyle = .wheels
            picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
            textField?.inputView = picker
            textField?.inputAccessoryView = makeDoneToolbar()
        }
    }

    private func makeDoneToolbar() -> UIToolbar {
        let bar = UIToolbar()
        bar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "done".localized, style: .done, target: self, action: #selector(dismissDatePicker))
        done.tintColor = UIColor(named: "Main")
        bar.items = [flex, done]
        return bar
    }

    // MARK: - Bindings -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$info
            .compactMap { $0 }
            .sinkOnMain { [weak self] item in
                self?.renderDelegate(item)
            }
            .store(in: &cancellables)

        viewModel.$canAddStorage
            .sinkOnMain { [weak self] value in
                guard let self else { return }
                pendingStorageToggle = false
                storageSwitch.setOn(value, animated: true)
            }
            .store(in: &cancellables)

        viewModel.$stats
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                self?.statsCollectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$settlement
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.amountLabel.text = result.totalCashReceived ?? "0"
                self?.settleButton.isHidden = !( result.settleButton ?? true)
            }
            .store(in: &cancellables)

        viewModel.$settleSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                self?.showPopup(title: "settlement_request_sent_to_admin".localized)
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                guard let self, pendingStorageToggle else { return }
                pendingStorageToggle = false
                storageSwitch.setOn(viewModel.canAddStorage, animated: true)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    private func renderInfoIfAvailable() {
        if let item = viewModel.info {
            renderDelegate(item)
        }
    }

    private func renderDelegate(_ item: DelegateRequestItem) {
        delegateNameLabel.text = item.name
        delegateAvatarImageView.setWith(item.image)
        let countryCode = "966"
        if let phone = item.phone, !phone.isEmpty {
            delegatePhoneLabel.text = "+\(countryCode) \(phone)"
        } else {
            delegatePhoneLabel.text = ""
        }
        storageSwitch.setOn(viewModel.canAddStorage, animated: false)
    }

    private func showPopup(title: String) {
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            self?.viewModel.fetchSettlement()
        }
    }

    // MARK: - Tabs -

    private func selectTab(_ tab: DelegateInfoTab) {
        viewModel.selectedTab = tab
        personalContainerView.isHidden = tab != .personal
        reportsContainerView.isHidden = tab != .reports
        settlementContainerView.isHidden = tab != .settlement
        updateTabAppearance(tab)
        switch tab {
        case .personal:
            break
        case .reports:
            viewModel.fetchStatistics()
        case .settlement:
            viewModel.fetchSettlement()
        }
    }

    private func updateTabAppearance(_ tab: DelegateInfoTab) {
        let tabs: [(DelegateInfoTab, UIButton)] = [
            (.personal, personalTabButton),
            (.reports, reportsTabButton),
            (.settlement, settlementTabButton)
        ]
        for (t, btn) in tabs {
            if t == tab {
                btn.backgroundColor = UIColor(named: "Main")
                btn.setTitleColor(.white, for: .normal)
                btn.layer.borderWidth = 0
            } else {
                btn.backgroundColor = .white
                btn.setTitleColor(.hint, for: .normal)
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.textFieldBorder.cgColor
            }
            btn.layer.cornerRadius = 12
        }
    }

    private func selectPeriod(_ period: StatisticsPeriod) {
        viewModel.selectedPeriod = period
        zip(periodButtons, StatisticsPeriod.allCases).forEach { btn, p in
            if p == period {
                btn.backgroundColor = UIColor(named: "Main")
                btn.setTitleColor(.white, for: .normal)
                btn.layer.borderWidth = 0
            } else {
                btn.backgroundColor = .white
                btn.setTitleColor(.hint, for: .normal)
                btn.layer.borderWidth = 1
                btn.layer.borderColor = UIColor.textFieldBorder.cgColor
            }
            btn.layer.cornerRadius = 12
        }
    }

    // MARK: - Actions -

    @IBAction func didTapPersonalTab(_ sender: UIButton) {
        selectTab(.personal)
    }

    @IBAction func didTapReportsTab(_ sender: UIButton) {
        selectTab(.reports)
    }

    @IBAction func didTapSettlementTab(_ sender: UIButton) {
        selectTab(.settlement)
    }

    @IBAction func didToggleStorage(_ sender: UISwitch) {
        pendingStorageToggle = true
        viewModel.toggleStorage()
    }

    @IBAction func didTapDaily(_ sender: UIButton) {
        selectPeriod(.daily)
        viewModel.fetchStatistics()
    }

    @IBAction func didTapWeekly(_ sender: UIButton) {
        selectPeriod(.weekly)
        viewModel.fetchStatistics()
    }

    @IBAction func didTapMonthly(_ sender: UIButton) {
        selectPeriod(.monthly)
        viewModel.fetchStatistics()
    }

    @IBAction func didTapYearly(_ sender: UIButton) {
        selectPeriod(.yearly)
        viewModel.fetchStatistics()
    }

    @IBAction func didTapFilterReset(_ sender: UIButton) {
        dateFromTextField.text = nil
        dateToTextField.text = nil
        viewModel.dateFrom = nil
        viewModel.dateTo = nil
        viewModel.fetchStatistics()
    }

    @IBAction func didTapSettle(_ sender: UIButton) {
        viewModel.settle()
    }

    @objc private func datePickerChanged(_ picker: UIDatePicker) {
        let str = dateFormatter.string(from: picker.date)
        if dateFromTextField.isFirstResponder {
            dateFromTextField.text = str
            viewModel.dateFrom = str
        } else if dateToTextField.isFirstResponder {
            dateToTextField.text = str
            viewModel.dateTo = str
        }
    }

    @objc private func dismissDatePicker() {
        view.endEditing(true)
        viewModel.fetchStatistics()
    }
}

// MARK: - UICollectionView -

extension DelegateInfoVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private func configureCollectionView() {
        statsCollectionView.register(cellType: StatCardCell.self)
        statsCollectionView.dataSource = self
        statsCollectionView.delegate = self
        statsCollectionView.isScrollEnabled = false
        statsCollectionView.backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = .zero
        statsCollectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.stats?.gridItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: StatCardCell.self, for: indexPath)
        if let item = viewModel.stats?.gridItems[indexPath.item] {
            cell.setupCell(entry: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 12) / 2
        return CGSize(width: width, height: 130)
    }
}


