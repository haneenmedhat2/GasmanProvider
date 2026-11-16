//
//  MainButton.swift
//  Cleaf
//
//  Created by Haneen Medhat on 26/04/2025.
//

import UIKit

class MainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInitialDesign()
        self.addPulsateAnimationWhenTapped()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupInitialDesign()
        self.addPulsateAnimationWhenTapped()
    }
    
    fileprivate func setupInitialDesign() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = UIColor.main
        self.titleLabel?.font = self.titleLabel?.font.withSize(16)
        self.setTitleColor(.white, for: .normal)
        if self.constraints.first(where: { $0.firstAttribute == .height }) == nil {
            self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    }
    
    private func addPulsateAnimationWhenTapped() {
        self.addTarget(self, action: #selector(self.flash), for: .touchUpInside)
    }
    
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}


class RedButton: MainButton {
    override func setupInitialDesign() {
        super.setupInitialDesign()
        self.backgroundColor = .redFont
    }
}

class GrayButton: MainButton {
    override func setupInitialDesign() {
        super.setupInitialDesign()
        self.backgroundColor = .systemGray4
        self.setTitleColor(.label, for: .normal)
    }
}
class CircleButton: MainButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height/2
        self.clipsToBounds = true
    }
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}

class CornerButton: UIButton {
    override func layoutSubviews() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
    }
    //MARK: - Deinit -
    deinit {
        print("\(self.className) is deinit, No memory leak found")
    }
}

// MARK: - Badge Button -

final class NotificationButtonView: UIView {

    private let button = UIButton(type: .system)
    private let badgeLabel = UILabel()

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: 38).isActive = true
        heightAnchor.constraint(equalToConstant: 38).isActive = true

        setupButton()
        setupBadge()
    }

    private func setupButton() {
        button.setImage(
            UIImage(resource: .notification).withRenderingMode(.alwaysOriginal),
            for: .normal
        )

        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.1
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4

        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupBadge() {
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .red
        badgeLabel.font = .systemFont(ofSize: 11, weight: .bold)
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true
        badgeLabel.isHidden = true

        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(badgeLabel)

        NSLayoutConstraint.activate([
            badgeLabel.topAnchor.constraint(equalTo: topAnchor, constant: -4),
            badgeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            badgeLabel.heightAnchor.constraint(equalToConstant: 18),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 18)
        ])

        badgeLabel.layer.cornerRadius = 9
    }

    @objc private func buttonTapped() {
        onTap?()
    }

    func updateBadge(count: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if count > 0 {
                self.badgeLabel.isHidden = false
                self.badgeLabel.text = "\(min(count, 99))"
            } else {
                self.badgeLabel.isHidden = true
            }
        }
    }
}

extension UIButton {
    
    func setUnderlinedTitle(
        _ title: String,
        color: UIColor? = nil,
        state: UIControl.State = .normal
    ) {
        var attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        if let color = color {
            attributes[.foregroundColor] = color
        }
        
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: attributes
        )
        
        self.setAttributedTitle(attributedTitle, for: state)
    }
}
