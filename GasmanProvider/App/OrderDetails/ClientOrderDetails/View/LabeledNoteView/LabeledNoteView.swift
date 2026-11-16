//
//  LabeledNoteView.swift
//  GasMan
//
//  Created by Haneen on 03/03/2026.
//

import UIKit

class LabeledNoteView: UIView {

    //MARK: - Outlets -

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

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
        let nib = UINib(nibName: "LabeledNoteView", bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    //MARK: - Configure -

    func configure(title: String, content: String) {
        titleLabel.text = title
        contentLabel.text = content
    }
}
