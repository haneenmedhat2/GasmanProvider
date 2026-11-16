//
//  StorageVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class StorageVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var canAddStorageSwitch: UISwitch!
    @IBOutlet weak var canAddStorageLabel: UILabel!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var requestStorageButton: UIButton!
    @IBOutlet weak var editStorageButton: UIButton!

    // MARK: - Properties -

    var viewModel: StorageVM

    // MARK: - Initializer -

    init(viewModel: StorageVM) {
        self.viewModel = viewModel
        super.init(nibName: "StorageVC", bundle: nil)
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
        super.viewWillAppear(animated)
        viewModel.fetchStorage()
        viewModel.getNotificationCount()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        setupNotificationButton()
        setupLeftBarButton()
        configureTableView()
        bindViewModel()
        viewModel.fetchStorage()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$categories
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$canAddStorage
            .sinkOnMain { [weak self] value in
                self?.canAddStorageSwitch.setOn(value, animated: true)
                self?.editStorageButton.isHidden = !value
            }
            .store(in: &cancellables)
        
        viewModel.$notificationCount
            .sinkOnMain { [weak self] count in
                self?.updateNotificationCount(count ?? 0)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapRequestStorage(_ sender: UIButton) {
        let vc = CreateMerchantOrderVC(viewModel: CreateMerchantOrderVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }

    @IBAction func didTapEditStorage(_ sender: UIButton) {
        let steel = viewModel.categories.first(where: { $0.categoryId == 1 })?.filled?.qty ?? 0
        let fiber = viewModel.categories.first(where: { $0.categoryId == 2 })?.filled?.qty ?? 0
        let vc = EditStorageVC(viewModel: EditStorageVM(steelQty: steel, fiberQty: fiber))
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}

// MARK: - UITableView -

extension StorageVC: UITableViewDataSource, UITableViewDelegate {
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: StorageCell.self)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
       return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: StorageCell.self, for: indexPath)
        let category = viewModel.categories[indexPath.section]
        let entry = category.rows[indexPath.row]
        cell.setupCell(entry: entry, isTotal: indexPath.row == 0)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let container = UIView()
        container.backgroundColor = .clear

        let label = UILabel()
        label.text = viewModel.categories[section].categoryName
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
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        16
    }
}
