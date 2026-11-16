//
//  StatisticsVC.swift
//  GasmanProvider
//

import UIKit
import Combine
import SDWebImage

class StatisticsVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var dailyButton: UIButton!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    @IBOutlet weak var yearlyButton: UIButton!

    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!

    @IBOutlet weak var generalContainerView: UIView!
    @IBOutlet weak var featuredCardView: UIView!
    @IBOutlet weak var featuredIconContainerView: UIView!
    @IBOutlet weak var featuredIconImageView: UIImageView!
    @IBOutlet weak var featuredValueLabel: UILabel!
    @IBOutlet weak var featuredTitleLabel: UILabel!
    @IBOutlet weak var statsCollectionView: CollectionViewContentSized!

    // MARK: - Properties -

    var viewModel: StatisticsVM

    private var periodButtons: [UIButton] = []

    private lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.calendar = Calendar(identifier: .gregorian)
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()

    // MARK: - Initializer -

    init(viewModel: StatisticsVM) {
        self.viewModel = viewModel
        super.init(nibName: "StatisticsVC", bundle: nil)
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
        self.title = "reports".localized
        periodButtons = [dailyButton, weeklyButton, monthlyButton, yearlyButton]
        configureCollectionView()
        setupDatePickers()
        bindViewModel()
        selectPeriod(.daily)
        viewModel.fetchGeneralStats()
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

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$generalStats
            .compactMap { $0 }
            .sinkOnMain { [weak self] stats in
                guard let self else { return }
                populateGeneralStats(stats)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    private func populateGeneralStats(_ stats: GeneralStatisticsData) {
        let featured = stats.cylindersNotReturned
        featuredValueLabel.text = "\(featured?.value ?? 0)"
        featuredTitleLabel.text = featured?.label
        featuredIconImageView.tintColor = .white
        statsCollectionView.reloadData()
    }

    // MARK: - Period -

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

    @IBAction func didTapDaily(_ sender: UIButton) {
        selectPeriod(.daily)
        viewModel.fetchGeneralStats()
    }

    @IBAction func didTapWeekly(_ sender: UIButton) {
        selectPeriod(.weekly)
        viewModel.fetchGeneralStats()
    }

    @IBAction func didTapMonthly(_ sender: UIButton) {
        selectPeriod(.monthly)
        viewModel.fetchGeneralStats()
    }

    @IBAction func didTapYearly(_ sender: UIButton) {
        selectPeriod(.yearly)
        viewModel.fetchGeneralStats()
    }

    @IBAction func didTapFilterReset(_ sender: UIButton) {
        dateFromTextField.text = nil
        dateToTextField.text = nil
        viewModel.dateFrom = nil
        viewModel.dateTo = nil
        viewModel.fetchGeneralStats()
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
        viewModel.fetchGeneralStats()
    }
}

// MARK: - UICollectionView -

extension StatisticsVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private func configureCollectionView() {
        statsCollectionView.register(cellType: StatCardCell.self)
        statsCollectionView.dataSource = self
        statsCollectionView.delegate = self
        statsCollectionView.isScrollEnabled = false
        statsCollectionView.backgroundColor = .clear

        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        statsCollectionView.collectionViewLayout = layout
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.generalStats?.gridItems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: StatCardCell.self, for: indexPath)
        if let item = viewModel.generalStats?.gridItems[indexPath.item] {
            cell.setupCell(entry: item)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 16) / 2
        return CGSize(width: width, height: 130)
    }
}
