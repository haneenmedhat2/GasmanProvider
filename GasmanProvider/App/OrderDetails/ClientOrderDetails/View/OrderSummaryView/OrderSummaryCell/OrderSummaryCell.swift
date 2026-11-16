//
//  OrderSummaryCell.swift
//  Profix
//
//  Created by Haneen on 16/01/2026.
//

import UIKit

class OrderSummaryCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Cell setup -

    func setupCell(model : KeyValueModel){
        keyLabel.text = model.title
        valueLabel.text = model.value
    }
    
    func applyStyle(isHighlighted: Bool) {
        if isHighlighted {
            keyLabel.textColor = .black
            keyLabel.font = UIFont.systemFont(ofSize: 16)
            valueLabel.font = UIFont.systemFont(ofSize: 16)
        } else {
            keyLabel.textColor = .hint
            keyLabel.font = UIFont.systemFont(ofSize: 12)
            valueLabel.font = UIFont.systemFont(ofSize: 12)
        }
    }
}
