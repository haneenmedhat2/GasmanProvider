//
//  ClientOrderCell.swift
//  GasmanProvider
//

import UIKit
import Kingfisher

class ClientOrderCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var statusBadgeView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var payStatusLabel: UILabel!
    @IBOutlet weak var rejectReasonLabel: UILabel!

    // Action buttons
    @IBOutlet weak var actionsStackView: UIStackView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!

    // MARK: - Properties -

    weak var delegate: ClientOrderCellDelegate?
    private var orderId: Int = 0

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configure -

    func setupCell(model: ClientOrder, orderStatus: OrderStatus) {
        orderId = model.id ?? 0

        orderNumLabel.text = "order_num".localized + "\(model.orderNum ?? "\(model.id ?? 0)")"
        customerNameLabel.text = model.userName
        orderDateLabel.text = "order_date".localized + " : " + (model.date ?? "")
        orderTimeLabel.text = "order_time".localized + " : " + (model.time ?? "")
        orderTypeLabel.text = "order_type".localized + " : " + (model.productsType ?? "")
        locationLabel.text = model.location
        priceLabel.text = (model.totalPrice ?? "") + " " + (model.currency ?? "")
        payStatusLabel.text = "pay_status".localized + " : " + (model.payStatus ?? "")

        // Status badge
        statusLabel.text = model.status?.title
        configureStatusBadge(for: orderStatus, statusName: model.status?.name)

        // Accept/Reject buttons
        let showAccept = model.acceptOrderButton == true
        let showReject = model.refuseOrderButton == true
        actionsStackView.isHidden = !showAccept && !showReject
        acceptButton.isHidden = !showAccept
        rejectButton.isHidden = !showReject

        // Reject reason
        if let reason = model.rejectReason, !reason.isEmpty {
            rejectReasonLabel.isHidden = false
            rejectReasonLabel.text = "rejection_reason".localized + " : " + reason
        } else {
            rejectReasonLabel.isHidden = true
        }
    }

    private func configureStatusBadge(for orderStatus: OrderStatus, statusName: String?) {
        switch orderStatus {
        case .new:
            statusBadgeView.backgroundColor = .main
            statusLabel.textColor = .black
        case .current:
            statusBadgeView.backgroundColor = .main
            statusLabel.textColor = .white
        case .finished:
            if statusName == "rejected" || statusName == "refuse" {
                statusBadgeView.backgroundColor = .warning
                statusLabel.textColor = .white
            } else {
                statusBadgeView.backgroundColor = .success
                statusLabel.textColor = .white
            }
        case .cancel:
            statusBadgeView.backgroundColor = .redFont
            statusLabel.textColor = .white
        }
    }

    // MARK: - Actions -

    @IBAction func didTapAccept(_ sender: UIButton) {
        delegate?.didTapAccept(orderId: orderId)
    }

    @IBAction func didTapReject(_ sender: UIButton) {
        delegate?.didTapReject(orderId: orderId)
    }

    @IBAction func didTapViewMore(_ sender: UIButton) {
        delegate?.didTapViewMore(orderId: orderId)
    }
}

protocol ClientOrderCellDelegate: AnyObject {
    func didTapAccept(orderId: Int)
    func didTapReject(orderId: Int)
    func didTapViewMore(orderId: Int)
}
