//
//  DelegateRequestCell.swift
//  GasmanProvider
//

import UIKit

protocol DelegateRequestCellDelegate: AnyObject {
    func delegateRequestCellDidTapApprove(_ cell: DelegateRequestCell)
    func delegateRequestCellDidTapReject(_ cell: DelegateRequestCell)
}

class DelegateRequestCell: UITableViewCell {

    // MARK: - Outlets -

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var approveButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!

    // MARK: - Properties -

    weak var delegate: DelegateRequestCellDelegate?

    // MARK: - Life Cycle -

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.textFieldBorder.cgColor
        containerView.clipsToBounds = true

        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.backgroundColor = .textFieldBorder
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }

    // MARK: - Setup -

    func setupCell(item: DelegateRequestItem) {
        nameLabel.text = item.name
        avatarImageView.setWith(item.image)
    }

    // MARK: - Actions -

    @IBAction func didTapApprove(_ sender: UIButton) {
        delegate?.delegateRequestCellDidTapApprove(self)
    }

    @IBAction func didTapReject(_ sender: UIButton) {
        delegate?.delegateRequestCellDidTapReject(self)
    }
}
