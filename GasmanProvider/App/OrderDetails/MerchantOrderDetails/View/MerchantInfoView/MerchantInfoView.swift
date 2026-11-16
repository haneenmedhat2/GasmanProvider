//
//  MerchantInfoView.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import UIKit
import Kingfisher

class MerchantInfoView: UIView {

    // MARK: - Outlets -

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
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
        let nib = UINib(nibName: "MerchantInfoView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    // MARK: - Setup -

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Configure -

    func configure(provider: ProviderInfo) {
        nameLabel.text = provider.name
        locationLabel.text = provider.mapDesc
        phoneLabel.text = "merchant_phone".localized
        profileImageView.kf.setImage(with: URL(string :provider.image ?? "") , placeholder: UIImage(resource: .blankProfile))
    
        if let phone = provider.phone, !phone.isEmpty {
            phoneLabel.text = phone
        }
    }
}
