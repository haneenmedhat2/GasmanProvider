//
//  ProviderTabBarController.swift
//  GasmanProvider
//

import UIKit

class ProviderTabBarController: UITabBarController {

    // MARK: - Properties -

    private var tabIndicators: [UIView] = []
    var selectedIdex = 0

    // MARK: - Lifecycle -

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTabIndicators(for: selectedIdex)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        initialView()
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }

        let timeInterval: TimeInterval = 0.4
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }

    private func updateTabIndicators(for selectedIndex: Int) {
        for (index, indicator) in tabIndicators.enumerated() {
            indicator.isHidden = index != selectedIndex
        }
    }

    // MARK: - Initial -

    static func create() -> ProviderTabBarController {
        return ProviderTabBarController()
    }

    // MARK: - Design -

    private func initialView() {
        setupDesign()
        addChilds()
    }

    private func addChilds() {
        self.viewControllers = [
            home(),
            orders(),
            stockTracking(),
            wallet(),
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

        let attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]
        tabBarAppearance.setBadgeTextAttributes(attribute, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attribute, for: .normal)

        if #available(iOS 15.0, *) {
            let tabFont = UIFont.systemFont(ofSize: 12)
            let appearance = UITabBarAppearance()

            let selectedAttributes: [NSAttributedString.Key: Any] = [.font: tabFont]
            let normalAttributes: [NSAttributedString.Key: Any] = [.font: tabFont, .foregroundColor: UIColor.gray]

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

    // MARK: - Tabs -

    func home() -> UINavigationController {
        let vc = ProviderHomeVC(viewModel: ProviderHomeVM())
        vc.tabBarItem = UITabBarItem(title: "home".localized, image: UIImage(resource: .home06), tag: 0)
        return BaseNav(rootViewController: vc)
    }

    func orders() -> UINavigationController {
        let vc = ProviderOrdersVC(viewModel: ProviderOrdersVM())

        let item = UITabBarItem( title: "my_orders".localized,image: UIImage(resource: .orders),tag: 1)

        item.badgeColor = .systemRed

        vc.tabBarItem = item
        return BaseNav(rootViewController: vc)
    }

    func stockTracking() -> UINavigationController {
        let vc = StockTrackingVC(viewModel: StockTrackingVM())
        vc.tabBarItem = UITabBarItem(title: "track".localized, image: UIImage(resource: .folderTransfer), tag: 2)
        return BaseNav(rootViewController: vc)
    }

    func wallet() -> UINavigationController {
        let vc = WalletVC(viewModel: WalletVM())
        vc.tabBarItem = UITabBarItem(title: "wallet".localized, image: UIImage(resource: .wallet), tag: 3)
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
}

// MARK: - UITabBarControllerDelegate -

extension ProviderTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = viewControllers?.firstIndex(of: viewController) else { return }
        selectedIdex = index
        updateTabIndicators(for: index)
    }
}

// MARK: - Routing -

extension ProviderTabBarController {
    func routeToNotifications() {
        let lastIndex = (viewControllers?.count ?? 1) - 1
        selectedIndex = lastIndex
        let nav = viewControllers![lastIndex] as! BaseNav
        nav.popToRootViewController(animated: false)

        let vc = NotificationVC(viewModel: NotificationVM())
        vc.hidesBottomBarWhenPushed = true
        nav.pushViewController(vc, animated: true)
    }
}
