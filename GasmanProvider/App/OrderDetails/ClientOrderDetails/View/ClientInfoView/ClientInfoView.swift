//
//  ClientInfoView.swift
//  GasmanProvider
//

import UIKit
import Kingfisher

class ClientInfoView: UIView {

    // MARK: - Outlets -

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    // MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // MARK: - XIB Loading -

    private func configureView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ClientInfoView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    // MARK: - Setup -

    override func awakeFromNib() {
        super.awakeFromNib()
        viewSetup()
    }

    private func viewSetup() {
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .textFieldBorder
    }

    // MARK: - Configure -

    func configure(client: Client?, phone: String?) {
        nameLabel.text = client?.name
        phoneLabel.text = "client_phone_number".localized

        if let urlStr = client?.image, let url = URL(string: urlStr) {
            profileImageView.kf.setImage(with: url)
        }

        if let phone = phone, !phone.isEmpty {
            phoneLabel.text = phone
        }
    }
}
