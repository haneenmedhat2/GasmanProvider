//
//  DelegateInfoView.swift
//  GasmanProvider
//
//  Created by Haneen on 06/04/2026.
//

import UIKit
import Kingfisher

class DelegateInfoView: UIView {

    // MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "DelegateInfoView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    // MARK: - Configure

    func configure(delegate: DelegateInfo) {
        nameLabel.text = delegate.name
        locationLabel.text = delegate.mapDesc
        profileImageView.kf.setImage(
            with: URL(string: delegate.image ?? ""),
            placeholder: UIImage(resource: .blankProfile)
        )

        phoneLabel.text = delegate.fullPhone ?? ""
    }
}
