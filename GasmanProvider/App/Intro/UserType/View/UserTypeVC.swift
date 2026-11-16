//
//  UserTypeVC.swift
//  GasmanProvider
//

import UIKit

class UserTypeVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var delegateButton: MainButton!
    @IBOutlet private weak var serviceProviderButton: MainButton!
    @IBOutlet private weak var languageButton: IconTextGeneralButton!

    //MARK: - Properties -
    
    override var navigationStyle: NavigationStyle { .white }

    // MARK: - Initializer -

    init() {
        super.init(nibName: "UserTypeVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLanguageButton()
    }

    // MARK: - Setup -

    private func setupLanguageButton() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChangeLanguage))
        languageButton.addGestureRecognizer(tap)
        languageButton.buttonLabel.font = .systemFont(ofSize: 12)
    }

    // MARK: - Actions -

    @IBAction private func delegateTapped(_ sender: MainButton) {
        selectType(.delegate_)
    }

    @IBAction private func serviceProviderTapped(_ sender: MainButton) {
        selectType(.serviceProvider)
    }

    @objc private func didTapChangeLanguage() {
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }

    // MARK: - Navigation -

    private func selectType(_ type: UserType) {
        Session.userType = type
        let vc = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav)
    }
}
