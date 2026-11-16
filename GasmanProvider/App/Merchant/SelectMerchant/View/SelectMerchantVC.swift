//
//  SelectMerchantVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class SelectMerchantVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectButton: UIButton!

    // MARK: - Properties -

    var viewModel: SelectMerchantVM

    // MARK: - Initializer -

    init(viewModel: SelectMerchantVM) {
        self.viewModel = viewModel
        super.init(nibName: "SelectMerchantVC", bundle: nil)
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
        self.title = "merchants".localized
        configureTableView()
        bindViewModel()
        updateSelectButtonState()
        viewModel.fetchProviders()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$providers
            .dropFirst()
            .sinkOnMain { [weak self] providers in
                guard let self else { return }
                tableView.reloadData()
                updateSelectButtonState()
            }
            .store(in: &cancellables)

        viewModel.$changeProvider
            .dropFirst()
            .sinkOnMain { [weak self] result in
                self?.show(successMessage: result?.message ?? "" )
                self?.pop()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    private func updateSelectButtonState() {
        let enabled = viewModel.selectedProviderId != nil && !viewModel.providers.isEmpty
        selectButton.isEnabled = enabled
        selectButton.alpha = enabled ? 1.0 : 0.5
    }

    // MARK: - Actions -

    @IBAction func didTapSelectButton(_ sender: UIButton) {
        viewModel.changeProviderRequest()
    }
}

// MARK: - UITableView -

extension SelectMerchantVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: MerchantListCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        tableView.setPlaceholder(isEmpty: viewModel.providers.isEmpty, separator: .none, style: .noMerchants)
        return viewModel.providers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MerchantListCell.self, for: indexPath)
        let provider = viewModel.providers[indexPath.row]
        cell.setupCell(provider: provider, isSelected: provider.id == viewModel.selectedProviderId)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedProviderId = viewModel.providers[indexPath.row].id
        tableView.reloadData()
        updateSelectButtonState()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard !viewModel.providers.isEmpty else { return nil }

        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.text = "certified_merchants".localized
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0)
        ])
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel.providers.isEmpty ? 0 : UITableView.automaticDimension
    }
}
