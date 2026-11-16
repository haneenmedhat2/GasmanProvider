//
//  MoreVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class MoreVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    let viewModel : MoreVM
    
    //MARK: - Initializer -
    
    init(viewModel : MoreVM){
        self.viewModel = viewModel
        super.init(nibName: "MoreVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.getNotificationCount()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        configureTableView()
        setupNotificationButton()
        setupLeftBarButton()
    }
    
    private var pendingReceiveToggle = false

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.signout
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                self.goToSplashScreen()
            }
            .store(in: &cancellables)

        viewModel.$receiveOrder
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                pendingReceiveToggle = false
                if let msg = result?.message, !msg.isEmpty {
                    show(successMessage: msg)
                }
                tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$error
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                guard let self, pendingReceiveToggle else { return }
                pendingReceiveToggle = false
                tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$notificationCount
            .sinkOnMain { [weak self] count in
                self?.updateNotificationCount(count ?? 0)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
}

//MARK: - Tableview Configuration -

extension MoreVC : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: MoreCell.self, bundle: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MoreCell.self, for: indexPath)
        cell.delegate = self
        let item = viewModel.menuItems[indexPath.row]
        let isSwitchOn: Bool
        switch item {
        case .availableForOrders:
            isSwitchOn = viewModel.receiveOrder?.data ?? (Session.provider?.canOrder ?? false)
        default:
            isSwitchOn = UserDefaults.isReceiveOrder
        }
        cell.setupCell(model: item, isSwitchEnabled: isSwitchOn)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.menuItems[indexPath.row]
        handleMenuSelection(item)
    }
    
    private func handleMenuSelection(_ item: MoreMenuItem) {
        switch item {
        case .profile:
            goToProfile()
        case .settings:
            goToSettigns()
        case .workLocation:
            goToWorkLocations()
        case .aboutUs:
            goToAboutUs()
        case .termsAndConditions:
            goToTermsAndConditions()
        case .complaints:
            goToComplaints()
        case .contactUs:
            goToContactUs()
        case .logout:
            viewModel.signoutRequest()
        case .changeLanguage:
            showLanguagePopup()
        case .wallet:
            goToWallet()
        case .FAQ:
            goToFAQ()
        case .myRatings:
            goToMyRatings()
        case .privacyPolicy:
            goToPrivacyPolicy()
        case .insurance:
            goToInsurance()
        case .statistics:
            goToStatistics()
        case .introVideo:
            goToTutorialVideo()
        case .invoices:
            goToInvoices()
        case .delegateRequests:
            goToDelegateRequests()
        case .availableForOrders:
            break
        default:
            break
        }
    }
}

//MARK: - Routes -

extension MoreVC {
    func goToProfile(){
        if Session.userType == .serviceProvider {
            let vc = ProviderProfileVC(viewModel: ProviderProfileVM())
            vc.hidesBottomBarWhenPushed = true
            push(vc)
        } else {
            let vc = ProfileVC(viewModel: ProfileVM())
            vc.hidesBottomBarWhenPushed = true
            push(vc)
        }
    }
    
    func goToUpdateProfile(){
        let vc = UpdateProfileVC(viewModel: UpdateProfileVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSettigns(){
        let vc = SettingsVC(viewModel: SettingsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToWallet(){
        let vc = WalletVC(viewModel: WalletVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToInsurance(){
        let vc = InsuranceVC(viewModel: InsuranceVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToStatistics(){
        if Session.userType == .serviceProvider {
            let vc = ProviderReportsVC(viewModel: ProviderReportsVM())
            vc.hidesBottomBarWhenPushed = true
            push(vc)
        } else {
            let vc = StatisticsVC(viewModel: StatisticsVM())
            vc.hidesBottomBarWhenPushed = true
            push(vc)
        }
    }

    func goToInvoices() {
        let vc = ProviderInvoicesVC(viewModel: ProviderInvoicesVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }

    func goToDelegateRequests() {
        let vc = DelegateRequestsVC(viewModel: DelegateRequestsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToWorkLocations(){
        let vc = WorkLocationsVC(viewModel: WorkLocationsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToComplaints(){
        let vc = ComplaintsVC(viewModel: ComplaintsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToContactUs(){
        let vc = ContactUsVC(viewModel: ContactUsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToFAQ(){
        let vc = FAQVC(viewModel: FAQVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToTermsAndConditions(){
        let vc = TermsAndConditionsVC(viewModel: TermsAndConditionsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToAboutUs(){
        let vc = AboutUsVC(viewModel: AboutUsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToPrivacyPolicy(){
        let vc = PrivacyPolicyVC(viewModel: PrivacyPolicyVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToTutorialVideo() {
        let vc = TutorialVideoVC(viewModel: TutorialVideoVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToMyRatings(){
        let vc = MyRatingsVC(viewModel: MyRatingsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    func goToSplashScreen(){
        UserDefaults.isLogin = false
        Session.user = nil
        Session.provider = nil
        Session.userType = nil
        Session.token = nil
        UserDefaults.isNotify = true

        let splashVC = SplashVC()
        AppHelper.changeWindowRoot(vc: splashVC)
    }
    
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
}

//MARK: - Double Action Popup  Delegation  -

extension MoreVC : DoubleActionPopupProtocol ,MoreCellProtocol{
    func didTapSwitch() {
        guard Session.userType == .serviceProvider else { return }
        pendingReceiveToggle = true
        viewModel.switchReceiveOrders()
    }

    func didTapSecondAction() {
        viewModel.signoutRequest()
    }
}
