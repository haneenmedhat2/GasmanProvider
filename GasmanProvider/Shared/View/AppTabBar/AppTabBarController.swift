//
//  AppTabBarController.swift
//  Waraqa
//
//  Created by Haneen on 07/08/2025.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    //MARK: - Properties -
    
    private var tabIndicators: [UIView] = []
    var selectedIdex = 0
    
    //MARK: - LifeCycle -
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabIndicators(for: selectedIdex)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.initialView()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item),
              let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        // Animate tab icon
        let timeInterval: TimeInterval = 0.4
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
        
        //        selectedIdex = index
        //        // Update indicator
        //        updateTabIndicators(for: index)
    }
    
    
    private func updateTabIndicators(for selectedIndex: Int) {
        for (index, indicator) in tabIndicators.enumerated() {
            indicator.isHidden = index != selectedIndex
        }
    }
    
    
    //MARK: - Initial -
    
    static func create() -> AppTabBarController {
        let vc = AppTabBarController()
        return vc
    }
    
    //MARK: - Design -
    private func initialView(){
        self.setupDesign()
        self.addChilds()
    }
    private func addChilds() {
        self.viewControllers = [
            home(),
            orders(),
            storage(),
            settlement(),
            more()
        ]
    }
    
    private func setupDesign() {
        let tabBarAppearance = UITabBarItem.appearance()
        UITabBar.appearance().tintColor = .main
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .textFieldBorder

        let attribute = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 12)]
        tabBarAppearance.setBadgeTextAttributes(attribute as [NSAttributedString.Key : Any], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attribute as [NSAttributedString.Key : Any], for: .normal)
        
        // Special Handling for iOS 15 and Above:
        if #available(iOS 15.0, *) {
            
            let tabFont =  UIFont.systemFont(ofSize: 12)
            
            let appearance = UITabBarAppearance()
            
            
            let selectedAttributes: [NSAttributedString.Key: Any]
            = [NSAttributedString.Key.font: tabFont]
            
            let normalAttributes: [NSAttributedString.Key: Any]
            = [NSAttributedString.Key.font: tabFont, NSAttributedString.Key.foregroundColor: UIColor.gray]
            
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            
            appearance.inlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            
            appearance.inlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = normalAttributes
            appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = selectedAttributes
            
            self.tabBar.standardAppearance = appearance
            self.tabBar.scrollEdgeAppearance = appearance
            
        }
    }
    
    //MARK: - Tabs -
    
    func home() -> UINavigationController {
        let vc = HomeVC(viewModel: HomeVM())
        vc.tabBarItem = UITabBarItem(title: "home".localized, image: UIImage(resource: .home06), tag: 0)
        
        return BaseNav(rootViewController: vc)
    }
    
    
    func merchant() -> UINavigationController {
        let vc = MerchantVC(viewModel: MerchantVM())
        vc.tabBarItem = UITabBarItem(title: "merchant".localized, image: UIImage(resource: .userStar01), tag: 1)
        return BaseNav(rootViewController: vc)
    }

    func orders() -> UINavigationController {
        let vc = OrderTypeVC(viewModel: OrderTypeVM())
        let item  = UITabBarItem(title: "myOrders".localized, image: UIImage(resource: .orders), tag: 1)
        
        item.badgeColor = .systemRed

        vc.tabBarItem = item
        return BaseNav(rootViewController: vc)
    }
    
    func storage() -> UINavigationController {
        let vc = StorageVC(viewModel: StorageVM())
        vc.tabBarItem = UITabBarItem(title: "storage".localized, image: UIImage(resource:.layers01 ), tag: 2)
        return BaseNav(rootViewController: vc)
    }

    func settlement() -> UINavigationController {
        let vc = SettlementVC(viewModel: SettlementVM())
        vc.tabBarItem = UITabBarItem(title: "settlement".localized, image: UIImage(resource: .settlement), tag: 3)
        return BaseNav(rootViewController: vc)
    }

    func more() -> UINavigationController {
        let vc = MoreVC(viewModel: MoreVM())
        vc.tabBarItem = UITabBarItem(title: "more".localized, image: UIImage(resource: .more), tag: 4)
        return BaseNav(rootViewController: vc)
    }
    
    func updateOrdersBadge(count: Int) {
        guard let items = tabBar.items, items.count > 1 else { return }

        let ordersItem = items[1]

        if count > 0 {
            ordersItem.badgeValue = "\(count)"
        } else {
            ordersItem.badgeValue = nil
        }
    }
    
    //MARK: - Middle Button -
    func addMiddleButton(){
        let actionButton = UIButton()
        let unSelectedImage = UIImage()
        let selectedImage = UIImage()
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setImage(unSelectedImage, for: .normal)
        actionButton.setImage(selectedImage, for: .selected)
        
        self.tabBar.addSubview(actionButton)
        self.tabBar.bringSubviewToFront(actionButton)
        
        actionButton.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor).isActive = true
        actionButton.centerYAnchor.constraint(equalTo: self.tabBar.centerYAnchor).isActive = true
        actionButton.heightAnchor.constraint(equalTo: self.tabBar.heightAnchor).isActive = true
        actionButton.widthAnchor.constraint(equalToConstant: self.tabBar.bounds.width / CGFloat(self.viewControllers?.count ?? 1)).isActive = true
        
        actionButton.isEnabled = true
        actionButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
    }
    func addMiddleImage(){
        let length: CGFloat = 64
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tab2")
        imageView.contentMode = .scaleAspectFill
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tabBar.addSubview(imageView)
        self.tabBar.bringSubviewToFront(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: self.tabBar.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: length).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: length).isActive = true
        imageView.layer.cornerRadius = length / 2
        
        
    }
    @objc private func middleButtonAction() {
        //        guard UserDefaults.isLogin else {
        //            AppAlert.showLogoutAlert {
        //                let vc = UIViewController() // show login
        //                let nav = BaseNav(rootViewController: vc)
        //                self.present(nav, animated: true)
        //            }
        //            return
        //        }
        //        self.present(self.addAds(), animated: true, completion: nil)
    }
}
extension AppTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        selectedIdex = index
        updateTabIndicators(for: index)
    }
}


extension AppTabBarController {

    func routeToOrder(_ id: Int) {
//        selectedIndex = 1
//        let nav = viewControllers![1] as! BaseNav
//        nav.popToRootViewController(animated: false)
//
//        let vc = OrderDetailsVC(viewModel: OrderDetailsVM(orderId: id))
//        vc.hidesBottomBarWhenPushed = true
//        nav.pushViewController(vc, animated: true)
    }

    func routeToNotifications() {
        selectedIndex = 4
        let nav = viewControllers![4] as! BaseNav
        nav.popToRootViewController(animated: false)

        let vc = NotificationVC(viewModel: NotificationVM())
        vc.hidesBottomBarWhenPushed = true
        nav.pushViewController(vc, animated: true)
    }
}
