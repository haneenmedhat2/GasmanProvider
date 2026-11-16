//
//  StockTrackingCylinderCell.swift
//  GasmanProvider
//

import UIKit

class StockTrackingCylinderCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cylinderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configure -

    func configure(with info: CylinderStockInfo) {
        nameLabel.text = info.label
        let qty = info.value ?? 0
        qtyLabel.text = "\("qty".localized)\(qty)"
        cylinderImageView.setWith(info.image)
    }
}
