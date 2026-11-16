//
//  CancelReasonPopup.swift
//  GasMan
//
//  Created by Haneen on 03/03/2026.
//

import UIKit

class CancelReasonPopup: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: TableViewContentSized!
    @IBOutlet weak var backButton: UIButton!

    //MARK: - Properties -

    var reasonList: [CancelReasonModel] = []
    var onCancel: ((CancelReasonModel) -> Void)?

    private var selectedIndex: IndexPath?
    private var selectedReason: CancelReasonModel?

    //MARK: - Initializer -

    init() {
        super.init(nibName: "CancelReasonPopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    //MARK: - Setup -

    func initialConfiguration() {
        configView()
        configureTableView()
    }

    func configView() {
        view.backgroundColor = .clear
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.isUserInteractionEnabled = true

        backButton.layer.cornerRadius = 12
        backButton.layer.borderWidth = 1
        backButton.layer.borderColor = UIColor.main.cgColor
        backButton.setTitleColor(.main, for: .normal)
        backButton.backgroundColor = .clear
        backButton.clipsToBounds = true

        let dimTap = UITapGestureRecognizer(target: self, action: #selector(onBackViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(dimTap)
    }

    //MARK: - Presentation -

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }

    func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

    //MARK: - Actions -

    @IBAction func didTapConfirm(_ sender: UIButton) {
        guard let reason = selectedReason else {
            show(errorMessage: ValidationError.unSelectedItem.localizedDescription)
            return
        }
        onCancel?(reason)
        hide()
    }

    @IBAction func didTapBack(_ sender: UIButton) {
        hide()
    }

    @objc private func onBackViewTapped() {
        hide()
    }
}

//MARK: - TableView -

extension CancelReasonPopup: UITableViewDataSource, UITableViewDelegate {

    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: CancelReasonCell.self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reasonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CancelReasonCell.self, for: indexPath)
        cell.setupCell(model: reasonList[indexPath.row], isSelected: indexPath == selectedIndex)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        selectedReason = reasonList[indexPath.row]
        tableView.reloadData()
    }
}
