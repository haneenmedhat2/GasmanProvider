//
//  ProfileImageDisplayView.swift
//  GasmanProvider
//

import UIKit

@IBDesignable
class ProfileImageDisplayView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var documentImageView: UIImageView!

    //MARK: - IBInspectable -

    @IBInspectable var titleTxt: String = "" {
        didSet { titleLabel?.text = titleTxt.localized }
    }

    //MARK: - Initializer -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    //MARK: - Nib Configuration -

    func loadViewFromNib(nibName: String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }

    func configureView() {
        let view = loadViewFromNib(nibName: "ProfileImageDisplayView")
        view.frame = bounds
        addSubview(view)
    }

    //MARK: - Public -

    func setImage(url: String?) {
        documentImageView?.setWith(url)
    }
}
