//
//  DelegateOverdueCell.swift
//  GasmanProvider
//

import UIKit

class DelegateOverdueCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configure -

    func configure(with delegate: DelegateOverdue) {
        nameLabel.text = delegate.name
        msgLabel.text = delegate.msg
        phoneLabel.text = delegate.phone
        let count = delegate.overdueCylindersCount ?? 0
        qtyLabel.text = "\("qty".localized)\(count)"
        profileImageView.setWith(delegate.image)
    }
}
