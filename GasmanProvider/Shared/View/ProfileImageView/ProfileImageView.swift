//
//  ProfileImageView.swift
//  UIKit Tempelate app
//
//  Created by Haneen Medhat on 16/04/2025.
//

import UIKit
import Kingfisher

@IBDesignable
class ProfileImageView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageContainerView: UIView!
    
    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    //MARK: - Nib file configuration -
    
    func loadViewFromNib(nibName:String) -> UIView {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func configureView(){
        let view = loadViewFromNib(nibName: "ProfileImageView")
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    //MARK: - Outlets -
    
    private func setupUI() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func setImage (url : String){
        imageView.kf.setImage(with: URL(string: url), options: [.onFailureImage(UIImage(resource: .blankProfile)),.transition(.fade(0.3))])
    }
    
    func setCameraAction(target: Any?, action: Selector) {
        cameraButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
