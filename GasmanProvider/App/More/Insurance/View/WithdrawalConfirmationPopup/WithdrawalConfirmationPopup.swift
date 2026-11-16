//
//  WithdrawalConfirmationPopup.swift
//  GasmanProvider
//

import UIKit

class WithdrawalConfirmationPopup: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var confirmButton: MainButton!

    // MARK: - Properties -

    var onConfirm: (() -> Void)?

    private let popupTitle: String
    private let amountText: String
    private let buttonTitle: String

    // MARK: - Initializer -

    init(title: String, amount: String, buttonTitle: String) {
        self.popupTitle = title
        self.amountText = amount
        self.buttonTitle = buttonTitle
        super.init(nibName: "WithdrawalConfirmationPopup", bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    // MARK: - Setup -

    private func configView() {
        view.backgroundColor = .clear
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        contentView.alpha = 0
        contentView.layer.cornerRadius = 20
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        titleLabel.text = popupTitle
        amountLabel.text = amountText
        confirmButton.setTitle(buttonTitle, for: .normal)

        let tap = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tap)
    }

    // MARK: - Appear / Hide -

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { self.show() }
    }

    private func show() {
        UIView.animate(withDuration: 0.3) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide(completion: (() -> Void)? = nil) {
        dismiss(animated: false, completion: completion)
    }

    // MARK: - Actions -

    @IBAction func didTapConfirm(_ sender: UIButton) {
        hide { [weak self] in
            self?.onConfirm?()
        }
    }

    @objc private func backViewTapped() {
        hide()
    }
}
