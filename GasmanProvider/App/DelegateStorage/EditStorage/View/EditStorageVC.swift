//
//  EditStorageVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class EditStorageVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!

    // MARK: - Properties -

    let viewModel: EditStorageVM

    // MARK: - Initializer -

    init(viewModel: EditStorageVM) {
        self.viewModel = viewModel
        super.init(nibName: "EditStorageVC", bundle: nil)
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
        title = "edit_storage".localized
        configureTableView()
        bindViewModel()
    }

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$updateSuccess
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result.message)
                self?.pop()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapConfirm(_ sender: UIButton) {
        viewModel.submit()
    }
}

// MARK: - TableView -

extension EditStorageVC: UITableViewDataSource, UITableViewDelegate, CylinderStepperCellDelegate {

    private func configureTableView() {
        tableView.register(cellType: CylinderStepperCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 2 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CylinderStepperCell.self, for: indexPath)
        let title = indexPath.row == 0 ? "metal_gas_cylinder".localized : "fiber_gas_cylinder".localized
        let count = indexPath.row == 0 ? viewModel.steelQty : viewModel.fiberQty
        cell.setupCell(title: title, count: count)
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.text = "full_cylinders_count".localized
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
        UITableView.automaticDimension
    }

    // MARK: - CylinderStepperCellDelegate -

    func cylinderStepperCell(_ cell: CylinderStepperCell, didChangeValue value: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if indexPath.row == 0 {
            viewModel.steelQty = value
        } else {
            viewModel.fiberQty = value
        }
    }
}
