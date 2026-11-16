//
//  ProviderOrderCell.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import UIKit
import Kingfisher

class ProviderOrderCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var statusBadgeView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var rejectReasonLabel: UILabel!
    @IBOutlet weak var delegateName: UILabel!
    @IBOutlet weak var actionButtonsStack: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!

    // MARK: - Properties -

    var onAccept: (() -> Void)?
    var onReject: (() -> Void)?

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        styleActionButtons()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onAccept = nil
        onReject = nil
    }

    // MARK: - Configure -

    func setupCell(model: ProviderOrder, orderStatus: OrderStatus) {
        orderNumLabel.text = "order_num".localized + " #" + (model.orderNum ?? "\(model.id ?? 0)")

        if let image = model.image, let url = URL(string: image) {
            logoImageView.kf.setImage(with: url, placeholder: UIImage(named: "smallAppIcon"))
        } else {
            logoImageView.image = UIImage(named: "smallAppIcon")
        }

        statusLabel.text = model.status?.title
        configureStatusBadge(for: orderStatus)

        delegateName.text = model.userName ?? ""
        orderDateLabel.text = "order_date".localized + " : " + (model.date ?? "")
        orderTimeLabel.text = "order_time".localized + " : " + (model.time ?? "")

        rejectReasonLabel.isHidden = true
        actionButtonsStack.isHidden = orderStatus != .new
    }

    private func styleActionButtons() {
        acceptButton.backgroundColor = .main
        rejectButton.backgroundColor = .redFont
    }

    private func configureStatusBadge(for orderStatus: OrderStatus) {
        switch orderStatus {
        case .new:
            statusBadgeView.backgroundColor = .main
            statusLabel.textColor = .black
        case .current:
            statusBadgeView.backgroundColor = .main
            statusLabel.textColor = .white
        case .finished:
            statusBadgeView.backgroundColor = .success
            statusLabel.textColor = .white
        case .cancel:
            statusBadgeView.backgroundColor = .redFont
            statusLabel.textColor = .white
        }
    }

    // MARK: - Actions -

    @IBAction func didTapAccept(_ sender: UIButton) {
        onAccept?()
    }

    @IBAction func didTapReject(_ sender: UIButton) {
        onReject?()
    }
}
