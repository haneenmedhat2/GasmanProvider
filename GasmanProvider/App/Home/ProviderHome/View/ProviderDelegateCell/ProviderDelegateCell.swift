//
//  ProviderDelegateCell.swift
//  GasmanProvider
//

import UIKit

class ProviderDelegateCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.textFieldBorder.cgColor
        containerView.clipsToBounds = true

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .textFieldBorder
        avatarImageView.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }

    // MARK: - Setup -

    func setupCell(item: DelegateRequestItem) {
        nameLabel.text = item.name
        avatarImageView.setWith(item.image)

        let countryCode = "966"
        if let phone = item.phone, !phone.isEmpty {
            phoneLabel.text = "+\(countryCode) \(phone)"
        } else {
            phoneLabel.text = ""
        }
    }
}
