//
//  ProductCell.swift
//  GasMan
//
//  Created by Haneen on 24/02/2026.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

    //MARK: - Outlets -
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var TotalQuantityView: UIView!
    @IBOutlet weak var totalQuantityLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var quantityView: UIView!
    //MARK: - Properties -

     weak var delegate: ProductCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func setupCell(model : CartItem, isOrderInquiry : Bool = false){
//        productImage.kf.setImage(with: URL(string: model.image ?? ""))
//        productNameLabel.text = model.productTitle
//        productTypeLabel.text = model.type
//        priceLabel.text = (model.qty?.toString() ?? "0") + " x " + (model.price?.toPrice ?? "0")
//        quantityLabel.text = model.qty?.toString()
//        totalQuantityLabel.text = "quantity".localized + "  " + (model.qty?.toString() ?? "0")
//        updateRemoveButtonState(quantity: model.qty ?? 0)
//        handleOrderInquiryCase( isOrderInquiry : isOrderInquiry)
//    }
    
    func setupCell(orderItem: OrderItem) {
        productImage.kf.setImage(with: URL(string: orderItem.image ?? ""))
        productNameLabel.text = orderItem.productTitle
        productTypeLabel.text = orderItem.type
        priceLabel.text = (orderItem.qty?.toString() ?? "0") + " x " + (orderItem.price?.toPrice ?? "0")
        totalQuantityLabel.text = "quantity".localized + "  " + (orderItem.qty?.toString() ?? "0")
        handleOrderInquiryCase(isOrderInquiry: true)
    }

    func handleOrderInquiryCase( isOrderInquiry : Bool) {
        if isOrderInquiry {
            deleteButton.isHidden = true
            TotalQuantityView.isHidden = false
            quantityView.isHidden = true

        } else {
            deleteButton.isHidden = false
            TotalQuantityView.isHidden = true
            quantityView.isHidden = false
        }
    }

    private func updateRemoveButtonState(quantity : Int) {
        removeButton.isEnabled = quantity > 1
        removeButton.alpha = quantity > 1 ? 1 : 0.4
    }


    //MARK: - Actions -

    @IBAction func didTapDeleteProduct(_ sender: UIButton) {
        delegate?.didTapDelete(cell: self)
    }
    
    
    @IBAction func didTapAdd(_ sender: UIButton) {
        delegate?.didTapAdd(cell: self)

    }
    
    
    @IBAction func didTapRemove(_ sender: UIButton) {
        delegate?.didTapRemove(cell: self)
    }
    
}

protocol ProductCellDelegate: AnyObject {
    func didTapDelete(cell: ProductCell)
    func didTapAdd(cell: ProductCell)
    func didTapRemove(cell: ProductCell)
}
