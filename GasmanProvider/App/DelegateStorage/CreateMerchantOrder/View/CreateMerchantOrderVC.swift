//
//  CreateMerchantOrderVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class CreateMerchantOrderVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendOrderButton: UIButton!

    // MARK: - Properties -

    let viewModel: CreateMerchantOrderVM

    // MARK: - Initializer -

    init(viewModel: CreateMerchantOrderVM) {
        self.viewModel = viewModel
        super.init(nibName: "CreateMerchantOrderVC", bundle: nil)
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
        self.title = "order_from_merchant".localized
        configureCollectionView()
        configureTableView()
        bindViewModel()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$orderCreated
            .dropFirst()
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result?.message ?? "")
                self?.pop()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapSendOrder(_ sender: UIButton) {
        viewModel.createOrder()
    }
}

// MARK: - CollectionView (Order Type Tabs) -

extension CreateMerchantOrderVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private func configureCollectionView() {
        collectionView.register(cellType: SelectableOptionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.orderTypes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SelectableOptionCell.self, for: indexPath)
        cell.setupCell(model: viewModel.orderTypes[indexPath.row], isSelected: viewModel.selectedIndex == indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath != viewModel.selectedIndex else { return }
        viewModel.selectedIndex = indexPath
        collectionView.reloadData()
        viewModel.orderType = indexPath.row == 0 ? .receive : .return
        viewModel.resetCounts()
        tableView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 12) / 2, height: 40)
    }
}

// MARK: - TableView (Cylinder Steppers) -

extension CreateMerchantOrderVC: UITableViewDataSource, UITableViewDelegate, CylinderStepperCellDelegate {

    private func configureTableView() {
        tableView.register(cellType: CylinderStepperCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.orderType == .receive ? 1 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CylinderStepperCell.self, for: indexPath)
        let title = indexPath.row == 0 ? "metal_gas_cylinder".localized : "fiber_gas_cylinder".localized
        let count = countForIndexPath(indexPath)
        cell.setupCell(title: title, count: count)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard viewModel.orderType == .return else { return nil }

        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.text = section == 0 ? "empty_cylinders_count".localized : "full_cylinders_count".localized
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.orderType == .return ? UITableView.automaticDimension : 0
    }

    // MARK: - CylinderStepperCellDelegate -

    func cylinderStepperCell(_ cell: CylinderStepperCell, didChangeValue value: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        setCount(value, for: indexPath)
    }

    // MARK: - Helpers -

    private func countForIndexPath(_ indexPath: IndexPath) -> Int {
        switch viewModel.orderType {
        case .receive:
            return indexPath.row == 0 ? viewModel.metalQty : viewModel.fiberQty
        case .return:
            if indexPath.section == 0 {
                return indexPath.row == 0 ? viewModel.emptyMetalQty : viewModel.emptyFiberQty
            } else {
                return indexPath.row == 0 ? viewModel.fullMetalQty : viewModel.fullFiberQty
            }
        }
    }

    private func setCount(_ value: Int, for indexPath: IndexPath) {
        switch viewModel.orderType {
        case .receive:
            if indexPath.row == 0 { viewModel.metalQty = value }
            else { viewModel.fiberQty = value }
        case .return:
            if indexPath.section == 0 {
                if indexPath.row == 0 { viewModel.emptyMetalQty = value }
                else { viewModel.emptyFiberQty = value }
            } else {
                if indexPath.row == 0 { viewModel.fullMetalQty = value }
                else { viewModel.fullFiberQty = value }
            }
        }
    }
}
