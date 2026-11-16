//
//  BaseNav.swift
//  Waraqa
//
//  Created by Haneen on 07/08/2025.
//

import Foundation
import UIKit

class BaseNav: UINavigationController {
    
    //MARK: - Properties -
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGesture()
        self.handleAppearance()
    }
    
    //MARK: - Design -
    
    func handleAppearance() {
        let backButtonImage = UIImage(resource: .backBtnAr)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black,  .font:UIFont.myBookFont(ofSize: 18)]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .main
        
        
        navigationBar.semanticContentAttribute = Language.isRTL() ? .forceRightToLeft : .forceLeftToRight
        view.semanticContentAttribute = navigationBar.semanticContentAttribute
        
    }
    
    private func setupGesture() {
        interactivePopGestureRecognizer?.delegate = self
        self.view.semanticContentAttribute = Language.isRTL() ? .forceRightToLeft : .forceLeftToRight
    }
}

extension BaseNav: UIGestureRecognizerDelegate {}
