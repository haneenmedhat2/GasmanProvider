//
//  SelectableOptionCell.swift
//  GasMan
//
//  Created by Haneen on 26/02/2026.
//

import UIKit

class SelectableOptionCell: UICollectionViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var selectionIcon: UIImageView!
    @IBOutlet weak var titleLAbel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(model : SelectionOptionType , isSelected : Bool){
        titleLAbel.text = model.title
        if let iconName = model.iconName {
            selectionIcon.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        } else if isSelected {
            selectionIcon.image = UIImage(systemName: "circle.inset.filled")
        } else {
            selectionIcon.image = UIImage(systemName: "circle")
        }
        selectionIcon.tintColor = isSelected ? .main : .hint
        titleLAbel.textColor = isSelected ? .black : .hint
    }
}
