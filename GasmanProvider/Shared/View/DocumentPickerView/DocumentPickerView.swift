//
//  DocumentPickerView.swift
//  GasmanProvider
//

import UIKit
@IBDesignable

class DocumentPickerView: UIView {

    // MARK: - Outlets -

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    @IBOutlet weak var imagesPickerView: ComplaintImagesView!

    // MARK: - Properties -

    var imagesList: [ComplaintImageItem] { imagesPickerView.imagesList }

    var onImagePicked: ((Data) -> Void)? {
        didSet { imagesPickerView.onImagePicked = onImagePicked }
    }

    func setImage(url: String?) {
        guard let url, !url.isEmpty else { return }
        imagesPickerView.setImage(url: url)
    }

    @IBInspectable var titleTxt: String = "" {
        didSet { titleLabel.text = titleTxt.localized }
    }

    @IBInspectable var requiredTxt: String = "" {
        didSet { requiredLabel.text = requiredTxt }
    }

    @IBInspectable var isRequiredProperty: Bool = true {
        didSet {
            requiredLabel.textColor = isRequiredProperty ? .systemRed : UIColor.border
        }
    }

    // MARK: - Initializer -

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    // MARK: - Nib Configuration -

    func loadViewFromNib(nibName: String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }

    func configureView() {
        let view = loadViewFromNib(nibName: "DocumentPickerView")
        view.frame = self.bounds
        self.addSubview(view)
        imagesPickerView.title.isHidden = true
        imagesPickerView.maxImages = 1
    }
}
