//
//  RateClientPopup.swift
//  GasmanProvider
//
//  Created by Haneen on 27/03/2026.
//

import UIKit
import Cosmos
import Kingfisher

class RateClientPopup: BaseViewController {

    //MARK: - Views -

    private let backView = UIView()
    private let contentView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let cosmosView = CosmosView()
    private let commentTextView = UITextView()
    private let confirmButton = MainButton()

    //MARK: - Properties -

    var client: Client?
    var orderId: Int = 0
    var onConfirm: ((RateClientModel) -> Void)?

    //MARK: - Initializer -

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateClient()
    }

    //MARK: - Setup UI -

    private func setupUI() {
        view.backgroundColor = .clear

        // Back view
        backView.backgroundColor = .black.withAlphaComponent(0.6)
        backView.alpha = 0
        backView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backView)
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: view.topAnchor),
            backView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let dimTap = UITapGestureRecognizer(target: self, action: #selector(onBackViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(dimTap)

        // Content view
        contentView.backgroundColor = .systemBackground
        contentView.alpha = 0
        contentView.layer.cornerRadius = 16
        contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Profile image
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .textFieldBorder
        profileImageView.layer.cornerRadius = 30
        profileImageView.translatesAutoresizingMaskIntoConstraints = false

        // Name label
        nameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Cosmos view
        cosmosView.settings.updateOnTouch = true
        cosmosView.settings.minTouchRating = 1
        cosmosView.settings.fillMode = .full
        cosmosView.settings.filledImage = UIImage(named: "filledStar")
        cosmosView.settings.emptyImage = UIImage(named: "emptyStar")
        cosmosView.settings.starSize = 30
        cosmosView.settings.starMargin = 6
        cosmosView.rating = 0
        cosmosView.translatesAutoresizingMaskIntoConstraints = false

        // Comment text view
        commentTextView.layer.cornerRadius = 12
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.textFieldBorder.cgColor
        commentTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        commentTextView.font = .systemFont(ofSize: 14)
        commentTextView.tintColor = .main
        commentTextView.text = "write_your_review_here".localized
        commentTextView.textColor = .placeholderText
        commentTextView.delegate = self
        commentTextView.translatesAutoresizingMaskIntoConstraints = false

        // Confirm button
        confirmButton.setTitle("rating".localized, for: .normal)
        confirmButton.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        // Stack view
        let stack = UIStackView(arrangedSubviews: [
            profileImageView, nameLabel, cosmosView,
            commentTextView, confirmButton
        ])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),

            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            nameLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: stack.trailingAnchor),

            commentTextView.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            commentTextView.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            commentTextView.heightAnchor.constraint(equalToConstant: 120),

            confirmButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: stack.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    //MARK: - Populate -

    private func populateClient() {
        nameLabel.text = client?.name
        if let urlStr = client?.image, let url = URL(string: urlStr) {
            profileImageView.kf.setImage(with: url)
        }
    }

    //MARK: - Presentation -

    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { self.show() }
    }

    func show() {
        UIView.animate(withDuration: 1, delay: 0.1) {
            self.backView.alpha = 1
            self.contentView.alpha = 1
        }
    }

    func hide() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }

    //MARK: - Actions -

    @objc private func didTapConfirm() {
        guard cosmosView.rating > 0 else {
            show(errorMessage: "please_rate_client".localized)
            return
        }

        let commentText = commentTextView.textColor == .placeholderText
            ? "" : commentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        guard !commentText.isEmpty else {
//            show(errorMessage: "please_write_your_comment".localized)
//            return
//        }

        let model = RateClientModel(
            orderId: orderId,
            userRate: Int(cosmosView.rating),
            userComment: commentText
        )

        onConfirm?(model)
        hide()
    }

    @objc private func onBackViewTapped() {
        hide()
    }
}

//MARK: - UITextViewDelegate -

extension RateClientPopup: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "write_your_review_here".localized
            textView.textColor = .placeholderText
        }
    }
}
