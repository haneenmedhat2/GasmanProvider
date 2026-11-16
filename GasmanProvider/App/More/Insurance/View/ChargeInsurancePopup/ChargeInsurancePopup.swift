//
//  ChargeInsurancePopup.swift
//  GasmanProvider
//

import UIKit
import Combine

class ChargeInsurancePopup: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var metalCountLabel: UILabel!
    @IBOutlet weak var fiberCountLabel: UILabel!

    // MARK: - Properties -

    weak var delegate: ChargeInsuranceDelegate?

    private var metalCount = 0
    private var fiberCount = 0

    // MARK: - Initializer -

    init() {
        super.init(nibName: "ChargeInsurancePopup", bundle: nil)
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

        let tap = UITapGestureRecognizer(target: self, action: #selector(backViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tap)

        updateCountLabels()
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

    // MARK: - Helpers -

    private func updateCountLabels() {
        metalCountLabel.text = "\(metalCount)"
        fiberCountLabel.text = "\(fiberCount)"
    }

    // MARK: - Actions -

    @IBAction func didTapIncrementMetal(_ sender: UIButton) {
        metalCount += 1
        updateCountLabels()
    }

    @IBAction func didTapDecrementMetal(_ sender: UIButton) {
        if metalCount > 0 { metalCount -= 1 }
        updateCountLabels()
    }

    @IBAction func didTapIncrementFiber(_ sender: UIButton) {
        fiberCount += 1
        updateCountLabels()
    }

    @IBAction func didTapDecrementFiber(_ sender: UIButton) {
        if fiberCount > 0 { fiberCount -= 1 }
        updateCountLabels()
    }

    @IBAction func didTapConfirm(_ sender: UIButton) {
        guard metalCount > 0 || fiberCount > 0 else {
            show(errorMessage: "please_enter_cylinder_count".localized)
            return
        }
        hide {
            self.delegate?.didConfirmCharge(metalQty: self.metalCount, fiberQty: self.fiberCount)
        }
    }

    @objc private func backViewTapped() {
        hide()
    }
}

// MARK: - Delegate Protocol -

protocol ChargeInsuranceDelegate: AnyObject {
    func didConfirmCharge(metalQty: Int, fiberQty: Int)
}
