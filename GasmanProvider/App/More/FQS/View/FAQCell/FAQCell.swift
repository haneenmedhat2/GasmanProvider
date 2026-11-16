//
//  FAQCell.swift
//  Esterad
//
//  Created by Haneen on 10/11/2025.
//

import Foundation
import UIKit

class FAQCell: UITableViewCell {
    
    static let identifier = "FAQCell"
    private let titleLabel = UILabel()
    private let detailLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let containerView = UIView()
    private let stackView = UIStackView()
    
    // MARK: - Init -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.textFieldBorder.cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .black
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        detailLabel.font = UIFont.systemFont(ofSize: 13)
        detailLabel.textColor = .black
        detailLabel.numberOfLines = 0
        detailLabel.isHidden = true
        
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, arrowImageView])
        titleStack.axis = .horizontal
        titleStack.alignment = .center
        titleStack.spacing = 8
        
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(titleStack)
        stackView.addArrangedSubview(detailLabel)
        
        containerView.addSubview(stackView)
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure -
    
    func configure(with item: ExpandableItem) {
        titleLabel.text = item.title
        detailLabel.text = item.details
        detailLabel.isHidden = !item.isExpanded
        
        let arrowName = item.isExpanded ? "arrowUp" : "arrow-down-01-round"
        arrowImageView.image = UIImage(named: arrowName)?.withRenderingMode(.alwaysTemplate)
        titleLabel.textColor = item.isExpanded ? .hint : .black
    }
}
