//
//  MyRatingsCell.swift
//  GasMan
//
//  Created by Haneen on 18/02/2026.
//

import UIKit
import Cosmos
import Kingfisher

class MyRatingsCell: UITableViewCell {
 
    //MARK: - Outlets -
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(model : Reviews){
        nameLabel.text = model.rater?.name
        ratingView.settings.updateOnTouch = false
        makeCosmosView(rating: Double(model.rate ?? 0))

        if let comment = model.comment, comment.isEmpty{
            contentLabel.text = "no_comment".localized
        } else {
            contentLabel.text = model.comment
        }
        
        avatar.kf.setImage(with: URL(string: model.rater?.image ?? ""), placeholder: UIImage(resource: .blankProfile),  options: [.onFailureImage(UIImage(resource: .blankProfile)), .transition(.fade(0.3))])
        
    }
    
    private func makeCosmosView(rating: Double) {
        ratingView.settings.updateOnTouch = false
        ratingView.settings.fillMode = .precise
        ratingView.settings.filledImage = UIImage(named: "filledStar")
        ratingView.settings.emptyImage = UIImage(named: "emptyStar")
        ratingView.settings.starSize = 10
        ratingView.settings.starMargin = 4
        ratingView.rating = rating
    }
}
