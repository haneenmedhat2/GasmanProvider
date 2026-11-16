//
//  MoreCell.swift
//  Esterad
//
//  Created by Haneen on 30/10/2025.
//

import UIKit

class MoreCell: UITableViewCell {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var containerStackView: UIStackView!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //MARK: - Properties -
    
    var delegate : MoreCellProtocol?
    
    //MARK: - Nib File Configurstion -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }
    
    func viewSetup() {
        notificationSwitch.addTarget(self, action: #selector(didChangeSwitch(_:)), for: .valueChanged)
    }
    
    func setupCell(model : MoreMenuItem ,isSwitchEnabled : Bool = true){
        containerStackView.backgroundColor = model.backgroundColor
        cellTitle.textColor = model.fontColor
        cellTitle.text = model.title
        cellTitle.font = model == .availableForOrders
            ? .systemFont(ofSize: 16, weight: .medium)
            : .systemFont(ofSize: 12, weight: .light)

        cellIcon.isHidden = model.isIconHidden
        cellIcon.image = model.isIconHidden ? nil : UIImage(named: model.icon)

        notificationSwitch.isHidden = model.isSwitchHidden
        notificationSwitch.isOn = isSwitchEnabled
    }
    
    //MARK: - Actions -
    
    @objc func didChangeSwitch(_ sender: UISwitch) {
        delegate?.didTapSwitch()
    }
}

//MARK: - Delegation -

protocol MoreCellProtocol {
    func didTapSwitch()
}

