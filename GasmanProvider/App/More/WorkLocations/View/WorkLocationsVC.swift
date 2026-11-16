//
//  WorkLocationsVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class WorkLocationsVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: TableViewContentSized!

    // MARK: - Properties -

    var viewModel: WorkLocationsVM

    // MARK: - Initializer -

    init(viewModel: WorkLocationsVM) {
        self.viewModel = viewModel
        super.init(nibName: "WorkLocationsVC", bundle: nil)
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
        self.title = "work_locations".localized
        configureTableView()
        bindViewModel()
        viewModel.getWorkPlaces()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$workPlaces
            .sinkOnMain { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapAddNewNeighborhood(_ sender: UIButton) {
        let vc = AddWorkPlaceVC(viewModel: AddWorkPlaceVM())
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}

// MARK: - AddWorkPlaceVCDelegate -

extension WorkLocationsVC: AddWorkPlaceVCDelegate {
    func addWorkPlaceDidSave() {
        viewModel.getWorkPlaces()
    }
}

// MARK: - TableView -

extension WorkLocationsVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: WorkPlaceCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.workPlaces.isEmpty, separator: .none, style: .workPlaces)
        return viewModel.workPlaces.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: WorkPlaceCell.self, for: indexPath)
        cell.setupCell(model: viewModel.workPlaces[indexPath.row])
        return cell
    }
}
