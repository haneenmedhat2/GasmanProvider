//
//  CancelReasonCell.swift
//  GasMan
//
//  Created by Haneen on 03/03/2026.
//

import UIKit

class CancelReasonCell: UITableViewCell {

    //MARK: - Outlets -

    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet weak var selectionImg: UIImageView!

    //MARK: - Cell Setup -

    func setupCell(model: CancelReasonModel, isSelected: Bool) {
        reasonLabel.text = model.title

        if isSelected {
            selectionImg.tintColor = .main
            selectionImg.image = UIImage(systemName: "circle.inset.filled")
            containerStackView.layer.borderColor = UIColor.main.cgColor
        } else {
            selectionImg.tintColor = .textFieldBorder
            selectionImg.image = UIImage(systemName: "circle")
            containerStackView.layer.borderColor = UIColor.textFieldBorder.cgColor
        }
    }
}
