//
//  AddWorkPlaceVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class AddWorkPlaceVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var tableView: TableViewContentSized!

    // MARK: - Properties -

    var viewModel: AddWorkPlaceVM
    weak var delegate: AddWorkPlaceVCDelegate?

    // MARK: - Initializer -

    init(viewModel: AddWorkPlaceVM) {
        self.viewModel = viewModel
        super.init(nibName: "AddWorkPlaceVC", bundle: nil)
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
        viewModel.getNeighborhoods()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$neighborhoods
            .sinkOnMain { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$toggleResult
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                guard let self else { return }
                showSuccessPopup(message: "neighborhood_selected_successfully".localized)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapConfirm(_ sender: UIButton) {
        guard viewModel.neighborhoods.contains(where: { $0.isSelected == true }) else {
            show(errorMessage: "please_select_work_place".localized)
            return
        }
        viewModel.toggleWorkPlaces()
    }
}

// MARK: - TableView -

extension AddWorkPlaceVC: UITableViewDataSource, UITableViewDelegate {

    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: AddWorkPlaceCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.neighborhoods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AddWorkPlaceCell.self, for: indexPath)
        cell.setupCell(model: viewModel.neighborhoods[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let current = viewModel.neighborhoods[indexPath.row].isSelected ?? false
        viewModel.neighborhoods[indexPath.row].isSelected = !current
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - Delegate Protocol -

protocol AddWorkPlaceVCDelegate: AnyObject {
    func addWorkPlaceDidSave()
}

// MARK: - Routes -

extension AddWorkPlaceVC {
    func showSuccessPopup(message: String) {
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: message)
        vc.onPopupHidden = { [weak self] in
            self?.delegate?.addWorkPlaceDidSave()
            self?.pop()
        }
    }
}
