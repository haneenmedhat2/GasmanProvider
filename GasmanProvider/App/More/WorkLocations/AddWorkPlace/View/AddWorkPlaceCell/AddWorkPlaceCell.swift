//
//  AddWorkPlaceCell.swift
//  GasmanProvider
//

import UIKit

class AddWorkPlaceCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var neighborhoodNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var checkboxImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Cell Setup -

    func setupCell(model: Neighborhood) {
        neighborhoodNameLabel.text = model.name
        cityNameLabel.text = model.city?.name
        setSelected(model.isSelected == true)
    }

    private func setSelected(_ isSelected: Bool) {
        if isSelected {
            containerStackView.layer.borderColor = UIColor.main.cgColor
            checkboxImageView.image = UIImage(systemName: "checkmark.square.fill")
            checkboxImageView.tintColor = .main
        } else {
            containerStackView.layer.borderColor = UIColor.textFieldBorder.cgColor
            checkboxImageView.image = UIImage(systemName: "square")
            checkboxImageView.tintColor = .lightGray
        }
    }
}
