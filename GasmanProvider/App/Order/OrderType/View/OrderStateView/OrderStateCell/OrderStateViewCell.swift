//
//  OrderCustomViewCell.swift
//  Cleaf
//
//  Created by Haneen on 02/06/2025.
//

import UIKit

class OrderStateViewCell: UICollectionViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellLabel: UILabel!
    
    //MARK: - Properties -
    
    //MARK: - Nib File Configuration -
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Setup Cell -
    
    func setupCell(orderStatus: OrderStatus){
        cellLabel.text = orderStatus.stringValue
    }
    
    func updateCellSelection(isCellSelected : Bool ){
        if isCellSelected {
            cellContentView.backgroundColor = .main
            cellContentView.layer.borderColor = .mainCGColor
            cellLabel.textColor = .white
        } else {
            cellContentView.backgroundColor = .white
            cellContentView.layer.borderColor = UIColor.textFieldBorder.cgColor
            cellLabel.textColor = .hint
        }
    }
}
