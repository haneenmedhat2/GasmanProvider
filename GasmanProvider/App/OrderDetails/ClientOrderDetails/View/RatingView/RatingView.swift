//
//  RatingView.swift
//  GasMan
//
//  Created by Haneen on 03/03/2026.
//

import UIKit
import Cosmos
import Kingfisher

class RatingView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    //MARK: - Init -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    //MARK: - XIB Loading -

    private func configureView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RatingView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    //MARK: - Setup -

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .textFieldBorder
        ratingView.settings.fillMode = .precise

    }

    //MARK: - Configure -

    func configure(myRate: MyRates) {
        nameLabel.text = myRate.name
        if let urlStr = myRate.image, let url = URL(string: urlStr) {
            profileImageView.kf.setImage(with: url)
        }

        ratingView.rating = myRate.rate ?? 0.0

        if let comment = myRate.comment, !comment.isEmpty {
            commentLabel.text = comment
        } else {
            commentLabel.text = "No comment was found ".localized
        }
    }

    func configure(userRate: UserRate) {
        nameLabel.text = userRate.rateable?.name
        if let urlStr = userRate.rateable?.image, let url = URL(string: urlStr) {
            profileImageView.kf.setImage(with: url)
        }

        ratingView.rating = userRate.rate ?? 0

        if let comment = userRate.comment, !comment.isEmpty {
            commentLabel.text = comment
        } else {
            commentLabel.text = "No comment was found ".localized
        }
    }
}
