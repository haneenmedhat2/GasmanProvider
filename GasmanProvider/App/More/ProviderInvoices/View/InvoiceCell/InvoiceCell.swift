//
//  InvoiceCell.swift
//  GasmanProvider
//

import UIKit

protocol InvoiceCellDelegate: AnyObject {
    func invoiceCellDidTapOpenInvoice(_ cell: InvoiceCell)
}

class InvoiceCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var openInvoiceButton: UIButton!

    // MARK: - Properties -

    weak var delegate: InvoiceCellDelegate?

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Setup -

    func setupCell(item: InvoiceItem) {
        let prefix = "order_number_hash".localized
        let orderNum = item.orderNum ?? ""
        orderNumberLabel.text = "\(prefix) \(orderNum)"

        let totalPrefix = "order_total".localized
        let total = item.total ?? "0"
        let currency = item.currency ?? ""
        totalLabel.text = "\(totalPrefix) : \(total) \(currency)"

       // logoImageView.setWith(item.logo)

        let title = "invoice_for_order".localized
        let attr = NSAttributedString(string: title, attributes: [
            .foregroundColor: UIColor.main,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ])
        openInvoiceButton.setAttributedTitle(attr, for: .normal)
    }

    // MARK: - Actions -

    @IBAction func didTapOpenInvoice(_ sender: UIButton) {
        delegate?.invoiceCellDidTapOpenInvoice(self)
    }
}
