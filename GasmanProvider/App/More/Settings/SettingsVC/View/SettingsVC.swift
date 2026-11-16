//
//  SettingsVC.swift
//  Esterad
//
//  Created by Haneen on 03/11/2025.
//

import UIKit
import Combine


class SettingsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    let viewModel :SettingsVM
    
    //MARK: - Initializer -
    
    init(viewModel :SettingsVM ){
        self.viewModel = viewModel
        super.init(nibName: "SettingsVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Initial Setup -
    
    func initialSetup() {
        self.title = "settings".localized
        configureTableView()
        bindToViewModel()
    }
    
    //MARK: -  Binding To ViewModel -
    
    func bindToViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$switchNotification
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                UserDefaults.isNotify = result?.data?.notify ?? true
            }
            .store(in: &cancellables)
        
        viewModel.$deleteAccount
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                show(successMessage: result?.message ?? "")
                self.goToLogin()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
}

//MARK: - TableView Configuration -

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MoreCell.self, bundle: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.settingsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MoreCell.self, for: indexPath)
        let item = viewModel.settingsItems[indexPath.row]
        cell.delegate = self
        cell.setupCell(model: item, isSwitchEnabled: UserDefaults.isNotify)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.settingsItems[indexPath.row]
        switch item {
        case .updateProfile:
            goToUpdateProfile()
        case .changephone:
            goToVerification()
        case .changeLanguage:
            showLanguagePopup()
        case .changePassword:
            goToChangePassword()
        case .deleteAccount:
            showDoubleActionPopup()
        default:
            break
        }
    }
}

//MARK: - Routes -

extension SettingsVC {
    
    func goToUpdateProfile(){
        if Session.userType == .serviceProvider {
            let vc = ProviderUpdateProfileVC(viewModel: ProviderUpdateProfileVM())
            push(vc)
        } else {
            let vc = UpdateProfileVC(viewModel: UpdateProfileVM())
            push(vc)
        }
    }
    
    func goToVerification(){
        if Session.userType == .serviceProvider {
            
            let vc = ChangePhoneVerifyVC(viewModel: ChangePhoneVerifyVM(mode: .oldPhone, phone: Session.provider?.phone ?? ""))
            push(vc, animated: true)
        } else {
            
            let vc = ChangePhoneVerifyVC(viewModel: ChangePhoneVerifyVM(mode: .oldPhone, phone: Session.user?.phone ?? ""))
            push(vc, animated: true)
        }
    }
    
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func showDoubleActionPopup(){
        let vc = DoubleActionPopupView()
        vc.delegate = self
        vc.appear(sender: self)
        vc.setupView(type: .deleteAccount)
    }
    
    func goToLogin(){
        UserDefaults.isLogin = false
        Session.user = nil
        Session.provider = nil
        Session.userType = nil
        Session.token = nil
        UserDefaults.isNotify = true

        let loginVC = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: loginVC)
        AppHelper.changeWindowRoot(vc: nav)
    }
    
    func goToChangePassword(){
        let vc = ChangePasswordVC(viewModel: ChangePasswordVM())
        push(vc)
    }
}

//MARK: - Delegation -

extension SettingsVC : MoreCellProtocol ,DoubleActionPopupProtocol{
    func didTapSwitch() {
        viewModel.switchNotificationRequest()
    }
    func didTapSecondAction() {
        viewModel.deleteAccountRequest()
    }
}

