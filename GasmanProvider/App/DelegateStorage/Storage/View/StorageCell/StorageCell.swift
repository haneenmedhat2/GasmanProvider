//
//  StorageCell.swift
//  GasmanProvider
//
//  Created by Haneen on 23/03/2026.
//

import UIKit

class StorageCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentView.clipsToBounds = true
    }

    // MARK: - Setup -

    func setupCell(entry: StorageEntry, isTotal: Bool) {
        nameLabel.text = entry.name
        qtyLabel.text = "\(entry.qty ?? 0)"

        if isTotal {
            contentView.backgroundColor = .offWhite
            nameLabel.textColor = .main
            qtyLabel.textColor = .main
            contentView.layer.cornerRadius = 12
            contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            contentView.backgroundColor = .white
            nameLabel.textColor = .black
            qtyLabel.textColor = .black
            contentView.layer.cornerRadius = 0
            contentView.layer.maskedCorners = []
        }
    }
}
