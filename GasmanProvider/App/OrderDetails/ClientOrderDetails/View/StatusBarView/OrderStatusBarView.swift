//
//  OrderStatusBarView.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

import UIKit

class OrderStatusBarView: UIView {

    private let stepCount  = 3
    private let circleSize: CGFloat = 32
    private let lineHeight: CGFloat = 3
    private let stepIcons  = [ "car-parking-02", "delivery-delay-01", "delivery-sent-02"]

    override init(frame: CGRect) { super.init(frame: frame) }
    required init?(coder: NSCoder) { super.init(coder: coder) }

    // title (~20) + spacing (8) + circle (40) + vertical padding (16 × 2)
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 100)
    }

    // currentStep is 1-based (1 = first step active). 0 = all grey.
    func configure(currentStep: Int, title: String? = nil) {
        subviews.forEach { $0.removeFromSuperview() }

        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 8
        container.alignment = .fill
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        // Title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .natural
        container.addArrangedSubview(titleLabel)

        // Bar stack
        let barStack = UIStackView()
        barStack.axis = .horizontal
        barStack.alignment = .center
        barStack.distribution = .fill
        container.addArrangedSubview(barStack)

        var firstLine: UIView?

        for i in 0..<stepCount {

            // MARK: - Line before circle
            if i > 0 {
                let lineContainer = UIView()
                lineContainer.translatesAutoresizingMaskIntoConstraints = false
                barStack.addArrangedSubview(lineContainer)
                lineContainer.heightAnchor.constraint(equalToConstant: lineHeight).isActive = true

                if let first = firstLine {
                    lineContainer.widthAnchor.constraint(equalTo: first.widthAnchor).isActive = true
                } else {
                    firstLine = lineContainer
                }

                // Grey background
                let bgLine = UIView()
                bgLine.backgroundColor = .textFieldBorder
                bgLine.translatesAutoresizingMaskIntoConstraints = false
                lineContainer.addSubview(bgLine)

                // Orange progress
                let progressLine = UIView()
                progressLine.backgroundColor = .main
                progressLine.translatesAutoresizingMaskIntoConstraints = false
                lineContainer.addSubview(progressLine)

                NSLayoutConstraint.activate([
                    bgLine.leadingAnchor.constraint(equalTo: lineContainer.leadingAnchor),
                    bgLine.trailingAnchor.constraint(equalTo: lineContainer.trailingAnchor),
                    bgLine.centerYAnchor.constraint(equalTo: lineContainer.centerYAnchor),
                    bgLine.heightAnchor.constraint(equalToConstant: lineHeight),

                    progressLine.leadingAnchor.constraint(equalTo: lineContainer.leadingAnchor),
                    progressLine.centerYAnchor.constraint(equalTo: lineContainer.centerYAnchor),
                    progressLine.heightAnchor.constraint(equalToConstant: lineHeight)
                ])

                // MARK: - Progress logic
                if (i - 1) < currentStep - 1 {
                    progressLine.widthAnchor.constraint(equalTo: lineContainer.widthAnchor).isActive = true
                } else if (i - 1) == currentStep - 1 {
                    progressLine.widthAnchor.constraint(equalTo: lineContainer.widthAnchor, multiplier: 0.5).isActive = true
                } else {
                    progressLine.widthAnchor.constraint(equalToConstant: 0).isActive = true
                }
            }

            // MARK: - Circle
            let isActive = i < currentStep

            let circle = UIView()
            circle.backgroundColor = isActive ? .main : .textFieldBorder
            circle.layer.cornerRadius = circleSize / 2
            circle.clipsToBounds = true
            circle.translatesAutoresizingMaskIntoConstraints = false
            barStack.addArrangedSubview(circle)

            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: circleSize),
                circle.heightAnchor.constraint(equalToConstant: circleSize)
            ])

            let iconView = UIImageView()
            iconView.image = UIImage(named: stepIcons[i])?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = .white
            iconView.contentMode = .scaleAspectFit
            iconView.translatesAutoresizingMaskIntoConstraints = false
            circle.addSubview(iconView)

            let iconSize = circleSize * 0.55
            NSLayoutConstraint.activate([
                iconView.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
                iconView.widthAnchor.constraint(equalToConstant: iconSize),
                iconView.heightAnchor.constraint(equalToConstant: iconSize)
            ])
        }
    }
}
