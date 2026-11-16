//
//  MerchantVC.swift
//  GasmanProvider
//

import UIKit
import Combine
import Kingfisher

class MerchantVC: BaseViewController {

    // MARK: - Outlets -

    // Empty state
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var selectButton: UIButton!

    // Profile state
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var orderNowButton: UIButton!
    @IBOutlet weak var changeMerchantButton: UIButton!

    // MARK: - Properties -

     let viewModel : MerchantVM

    // MARK: - Initializer -

    init(viewModel : MerchantVM) {
        self.viewModel = viewModel
        super.init(nibName: "MerchantVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchProfile()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        setupNotificationButton()
        setupLeftBarButton()
        bindViewModel()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$provider
            .dropFirst()
            .sinkOnMain { [weak self] provider in
                guard let self else { return }
                if let provider {
                    populateProfile(provider)
                    emptyView.isHidden = true
                    profileView.isHidden = false
                } else {
                    emptyView.isHidden = false
                    profileView.isHidden = true
                }
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)

    }

    private func populateProfile(_ provider: MerchantProvider) {
        nameLabel.text = provider.name
        locationLabel.text = provider.mapDesc
        if let distance = provider.distance {
            distanceLabel.text = String(format: "distance_from_you".localized, distance)
        } else {
            distanceLabel.text = nil
        }
        phoneLabel.text = provider.fullPhone

        let placeholder = UIImage(resource: .blankProfile)
        avatarImageView.kf.setImage(
            with: URL(string: provider.image ?? ""),
            placeholder: placeholder,
            options: [.transition(.fade(0.3))]
        )
    }

    // MARK: - Actions -

    @IBAction func didTapSelectMerchant(_ sender: UIButton) {
        goToSelectMerchant()
    }

    @IBAction func didTapChangeMerchant(_ sender: UIButton) {
        goToSelectMerchant()
    }

    @IBAction func didTapOrderNow(_ sender: UIButton) {
        goToCreateMerchantOrder()
    }
}

//MARK: - Routes -

extension MerchantVC {
    private func goToSelectMerchant() {
        let vc = SelectMerchantVC(viewModel: SelectMerchantVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
    
    private func goToCreateMerchantOrder() {
        let vc = CreateMerchantOrderVC(viewModel: CreateMerchantOrderVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
    }
}
