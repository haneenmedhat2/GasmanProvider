//
//  MerchantOrderCell.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import UIKit
import Kingfisher

class MerchantOrderCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var statusBadgeView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var rejectReasonLabel: UILabel!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configure -

    func setupCell(model: MerchantOrder, orderStatus: OrderStatus) {
        orderNumLabel.text = "order_num".localized + (model.orderNum ?? "\(model.id ?? 0)")
        
        // Status badge
        statusLabel.text = model.status
        configureStatusBadge(for: orderStatus)

        // Product type
        productTypeLabel.text = "product_type".localized + " : " + (model.productsCategories ?? "")

        // Order type
        orderTypeLabel.text = "order_type".localized + " : " + (model.type ?? "")

        // Date & Time
        orderDateLabel.text = "order_date".localized + " : " + (model.date ?? "")
        orderTimeLabel.text = "order_time".localized + " : " + (model.time ?? "")

        // Location
        if let loc = model.location, !loc.isEmpty {
            locationLabel.text = loc
            locationLabel.isHidden = false
        } else {
            locationLabel.isHidden = true
        }

        // Reject reason
        if let reason = model.rejectReason, !reason.isEmpty {
            rejectReasonLabel.text = "rejection_reason".localized + " : " + reason
            rejectReasonLabel.isHidden = false
        } else {
            rejectReasonLabel.isHidden = true
        }
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
}
