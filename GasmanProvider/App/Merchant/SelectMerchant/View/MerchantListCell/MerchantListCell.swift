//
//  MerchantListCell.swift
//  GasmanProvider
//

import UIKit
import Kingfisher

class MerchantListCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var radioButton: UIButton!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        avatarImageView.layer.cornerRadius = 30
        avatarImageView.clipsToBounds = true
    }

    // MARK: - Setup -

    func setupCell(provider: MerchantProvider, isSelected: Bool) {
        nameLabel.text = provider.name
        locationLabel.text = provider.mapDesc
        if let distance = provider.distance {
            distanceLabel.text = String(format: "distance_from_you".localized, distance)
        } else {
            distanceLabel.text = nil
        }

        let placeholder = UIImage(systemName: "person.circle.fill")
        avatarImageView.kf.setImage(
            with: URL(string: provider.image ?? ""),
            placeholder: placeholder,
            options: [.transition(.fade(0.3))]
        )

        let radioImage = isSelected
            ? UIImage(systemName: "circle.inset.filled")
            : UIImage(systemName: "circle")
        radioButton.setImage(radioImage, for: .normal)
        radioButton.tintColor = isSelected ? .main : .lightGray
    }
}
