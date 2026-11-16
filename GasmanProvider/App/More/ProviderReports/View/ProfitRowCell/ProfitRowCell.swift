//
//  ProfitRowCell.swift
//  GasmanProvider
//

import UIKit

class ProfitRowCell: UICollectionViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    // MARK: - Setup -

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        iconContainerView.layer.cornerRadius = 8
        iconContainerView.clipsToBounds = true
    }

    func setupCell(item: ProfitStatisticsItem) {
        titleLabel.text = item.label
        let value = item.value ?? "0"
        let currency = item.currency ?? ""
        valueLabel.text = currency.isEmpty ? value : "\(value) \(currency)"
        iconImageView.image = UIImage(named: sfSymbol(for: item.icon ?? ""))?
            .withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .white
    }

    private func sfSymbol(for icon: String) -> String {
        switch icon {
        case "trending-up":            return "shipping-truck-01"
        case "credit-card":            return "shipping-truck-01"
        case "dollar-sign", "dollar":  return "shipping-truck-01"
        default:                       return "shipping-truck-01"
        }
    }
}
