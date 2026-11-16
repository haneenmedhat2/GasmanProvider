//
//  CylinderStepperCell.swift
//  GasmanProvider
//

import UIKit

class CylinderStepperCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    // MARK: - Properties -

    weak var delegate: CylinderStepperCellDelegate?
    private var count = 0

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Setup -

    func setupCell(title: String, count: Int) {
        titleLabel.text = title
        self.count = count
        countLabel.text = "\(count)"
    }

    // MARK: - Actions -

    @IBAction func didTapIncrement(_ sender: UIButton) {
        count += 1
        countLabel.text = "\(count)"
        delegate?.cylinderStepperCell(self, didChangeValue: count)
    }

    @IBAction func didTapDecrement(_ sender: UIButton) {
        guard count > 0 else { return }
        count -= 1
        countLabel.text = "\(count)"
        delegate?.cylinderStepperCell(self, didChangeValue: count)
    }
}

protocol CylinderStepperCellDelegate: AnyObject {
    func cylinderStepperCell(_ cell: CylinderStepperCell, didChangeValue value: Int)
}
