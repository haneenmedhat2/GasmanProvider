//
//  NotificationVC.swift
//  Esterad
//
//  Created by Haneen on 09/12/2025.
//

import UIKit
import Combine

class NotificationVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    var viewModel : NotificationVM
    let refreshController = UIRefreshControl()
    
    //MARK: - Initializer -
    
    init(viewModel :NotificationVM){
        self.viewModel = viewModel
        super.init(nibName: "NotificationVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    private func initialConfiguration(){
        self.title = "notifications".localized
        NotificationCountManager.shared.markAllAsRead()
        viewModel.getNotification()
        configureTableView()
        bindToViewModel()
        setupRefreshControl()
        setupDeleteAllButton()
    }
    
    private func setupDeleteAllButton(){
        let button = UIButton(type: .system)
        button.setTitle("delete_all".localized, for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(deleteAllTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func deleteAllTapped(){
        showDoubleActionPopup()
    }
    
    func setupRefreshControl(){
        refreshController.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    
    //MARK: - ViewModel binding -
    
    private func bindToViewModel(){
        loading(viewModel.$isLoading)
        
        viewModel.$notification
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.refreshController.endRefreshing()
                self.tableView.reloadData()
                self.navigationItem.rightBarButtonItem?.customView?.isHidden = self.viewModel.notificationList.isEmpty
            }
            .store(in: &cancellables)
        
        viewModel.$deleteNotification
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result.message)
            }
            .store(in: &cancellables)
        
        viewModel.$deleteAllNotification
            .compactMap { $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.show(successMessage: result.message)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    //MARK: - Action -
    
    @objc func refreshData(){
        viewModel.resetData()
        viewModel.getNotification()
    }
}

//MARK: - TableView Configutations -

extension NotificationVC : UITableViewDelegate , UITableViewDataSource {
    
    private func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: NotificationCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.notificationList.isEmpty , separator: .none, style: .notifications)
        return viewModel.notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NotificationCell.self, for: indexPath)
        cell.delegate = self
        let item = viewModel.notificationList[indexPath.row]
        cell.setupCell(model: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.notificationList[indexPath.row]
        switch item.notificationEnum {
        case .receiveDueFinancingFromOrder:
            goToWallet()
            
        case .delegateJoinRequestToProvider:
            routeToDelegateRequest(data: item.data)
            
        case  .providerRefuseReceiveOrder,
                .providerAcceptReceiveOrder,
                .providerRefuseReturnOrder,
                .providerAcceptReturnOrder,
                .finishedProviderOrder,
                .newProviderReturnOrder,
                .newProviderReceiveOrder,
                .deliveredToProviderReturnOrder,
                .cancelledProviderOrder,
                .userWarningNoResponse:
            routeToOrderDetails(data: item.data)
            
        case .rateOrderToProvider:
            routeToDelegateRatings()

        case .delegateProfileUpdateRequestAccepted,
                .delegateProfileUpdateRequestRejected,
                .providerStoreUpdateRequestAccepted,
                .providerStoreUpdateRequestRejected:
            goToUpdateProfile()

        case .providerWalletWithdrawalRequestAccepted,
                .providerWalletWithdrawalRequestRejected:
            goToWallet()
            
        case .delegateInsuranceWithdrawalRequestAccepted,
                .delegateInsuranceWithdrawalRequestRejected:
            goToInsurance()

        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.notificationList.count - 1,
           !viewModel.isLastPage {
            viewModel.getNotification()
        }
    }
}

//MARK: - Routes -
extension NotificationVC {
    
    func showPopup(title : String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
    }
    
    func showDoubleActionPopup(){
        let vc = DoubleActionPopupView()
        vc.delegate = self
        vc.appear(sender: self)
        vc.setupView(type: .deleteNotifications)
    }
    
    func routeToOrderDetails(data: NotificationData?) {
        guard let orderId = data?.orderId?.toInt(), orderId > 0 else { return }
        if Session.userType == .serviceProvider {
            let vc = ProviderOrderDetailsVC(viewModel: ProviderOrderDetailsVM(orderId: orderId))
            push(vc)
        } else {
            if data?.orderType == "0" {
                let vc = ClientOrderDetailsVC(viewModel: ClientOrderDetailsVM(orderId: orderId))
                push(vc)
            } else {
                let vc = MerchantOrderDetailsVC(viewModel: MerchantOrderDetailsVM(orderId: orderId))
                push(vc)
            }
        }
    }
    
    func routeToDelegateRequest(data: NotificationData?) {
        guard let delegateId = data?.delegateId?.toInt(), delegateId > 0 else { return }
        let vc = DelegateRequestInfoVC(viewModel: DelegateRequestInfoVM(requestId: delegateId))
        push(vc)
    }
    
    func routeToDelegateRatings() {
        let vc = MyRatingsVC(viewModel: MyRatingsVM())
        push(vc)
    }
    
    func goToProfile(){
        let vc = ProfileVC(viewModel: ProfileVM())
        push(vc)
    }

    func goToUpdateProfile() {
        if Session.userType == .serviceProvider {
            let vc = ProviderUpdateProfileVC(viewModel: ProviderUpdateProfileVM())
            push(vc)
        } else {
            let vc = UpdateProfileVC(viewModel: UpdateProfileVM())
            push(vc)
        }
    }
    
    func goToWallet(){
        let vc = WalletVC(viewModel: WalletVM())
        push(vc)
    }
    
    func goToInsurance(){
        let vc = InsuranceVC(viewModel: InsuranceVM())
        push(vc)
        
    }
}

//MARK: - Protocol Confirmation -

extension NotificationVC : NotificationCellProtocol,DoubleActionPopupProtocol {
    func didTapDelete(notificationId: String) {
        viewModel.notificationId = notificationId
        viewModel.deleteNotificationRequest()
    }
    func didTapSecondAction() {
        viewModel.deleteAllNotifications()
    }
}
