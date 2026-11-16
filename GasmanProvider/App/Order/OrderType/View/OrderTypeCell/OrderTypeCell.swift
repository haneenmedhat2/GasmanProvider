//
//  OrderTypeCell.swift
//  GasmanProvider
//
//  Created by Haneen on 24/03/2026.
//

import UIKit

class OrderTypeCell: UITableViewCell {

    @IBOutlet weak var orderTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(title : String){
        orderTypeLabel.text = title
    }
}
