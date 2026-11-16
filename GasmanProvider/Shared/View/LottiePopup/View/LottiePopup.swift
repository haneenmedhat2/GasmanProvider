//
//  LottiePopup.swift
//  Esterad
//
//  Created by Haneen on 04/11/2025.
//

import UIKit
import SDWebImage

class LottiePopup: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var successTitle: UILabel!
    @IBOutlet weak var gifImageView: UIImageView!
    
    //MARK: - Properties -
    
    var onPopupHidden: (() -> Void)?

    //MARK: - Initializer  -
    
    init() {
        super.init(nibName: "LottiePopup", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    //MARK: - View Configuration -
    
    func configView(){
        self.view.backgroundColor = .clear
        self.backView.backgroundColor  = .black.withAlphaComponent(0.6)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        contentView.isUserInteractionEnabled = true
    }
    
    func setupView(title : String) {
        successTitle.text = title
        if let url = Bundle.main.url(forResource: "Done", withExtension: "gif") {
            gifImageView.sd_setImage(with: url)
        }
    }
    
    func appear(sender:UIViewController){
        sender.present(self, animated: false){
            self.show()
        }
    }
    
    func show(){
        UIView.animate(withDuration: 1, delay: 0.1){
            self.backView.alpha = 1
            self.contentView.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.hide()
            }
        }
    }
    
    func hide(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
            self.backView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false){
                self.onPopupHidden?()
            }
            self.removeFromParent()
        }
    }
}
