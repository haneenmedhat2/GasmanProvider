//
//  WorkPlaceCell.swift
//  GasmanProvider
//

import UIKit

class WorkPlaceCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var neighborhoodNameLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    // MARK: - Cell Setup -

    func setupCell(model: Neighborhood) {
        neighborhoodNameLabel.text = model.name
        cityNameLabel.text = model.city?.name
    }
}
