//
//  StatCardCell.swift
//  GasmanProvider
//

import UIKit

class StatCardCell: UICollectionViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Setup -

    func setupCell(entry: StatEntry) {
        valueLabel.text = "\(entry.value ?? 0)"
        titleLabel.text = entry.label
        iconImageView.image = UIImage(named: sfSymbol(for: entry.icon ?? ""))?
            .withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = .white
    }

    private func sfSymbol(for icon: String) -> String {
        switch icon {
        case "truck":         return "shipping-truck-01"
        case "clock":         return "package-process"
        case "package":       return "package"
        case "refresh":       return "package-add"
        case "refresh-cw":    return "package"
        case "dollar", "dollar-sign": return "return-request"
        case "trending-up":   return "safe-delivery-01"
        case "check-circle":  return "checkmark.circle.fill"
        case "x-circle":      return "package-out-of-stock"
        case "ban":           return "package-out-of-stock"
        default:              return "package-out-of-stock"
        }
    }
}
