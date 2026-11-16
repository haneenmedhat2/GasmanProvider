//
//  ProviderProfileVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ProviderProfileVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var storeNameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: GeneralTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var commercialNumberTextField: GeneralTextField!
    @IBOutlet weak var commercialEndDateTextField: DatePickerField!
    @IBOutlet weak var cityTextField: GeneralTextField!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var identityImageDisplayView: ProfileImageDisplayView!
    @IBOutlet weak var bankNameTextField: GeneralTextField!
    @IBOutlet weak var bankAccountTextField: GeneralTextField!
    @IBOutlet weak var ibanTextField: GeneralTextField!

    // MARK: - Properties -

    var viewModel: ProviderProfileVM

    // MARK: - Initializer -

    init(viewModel: ProviderProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderProfileVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    // MARK: - Setup -

    private func initialConfiguration() {
        self.title = "profile".localized
        disableAllTextFields()
        bindViewModel()
        viewModel.profileRequest()
    }

    private func disableAllTextFields() {
        [storeNameTextField, phoneTextField, emailTextField,
         commercialNumberTextField, cityTextField, locationTextField,
         bankNameTextField, bankAccountTextField, ibanTextField].forEach {
            $0?.txtField.isUserInteractionEnabled = false
        }
        commercialEndDateTextField.txtField.isUserInteractionEnabled = false
        profileImageView.cameraButton.isHidden = true
    }

    private func applyHintColor() {
        [storeNameTextField.txtField,
         phoneTextField.txtField, emailTextField.txtField,
         commercialNumberTextField.txtField, commercialEndDateTextField.txtField,
         cityTextField.txtField, locationTextField.txtField,
         bankNameTextField.txtField, bankAccountTextField.txtField,
         ibanTextField.txtField].forEach { $0.textColor = .hint }
    }

    // MARK: - Data Pre-population -

    private func setupProviderData() {
        guard let provider = Session.provider else { return }

        // Profile image
        if let url = provider.image {
            profileImageView.setImage(url: url)
        }

        // Store name
        storeNameTextField.txtField.text = provider.storeName

        // Phone
        phoneTextField.txtField.text = provider.phone

        // Email - hide if empty
        emailTextField.isHidden = true

        // Commercial
        commercialNumberTextField.txtField.text = provider.commercialNumber
        commercialEndDateTextField.txtField.text = provider.commercialEndDate

        // City
        cityTextField.txtField.text = provider.city?.name

        // Location
        locationTextField.txtField.text = provider.mapDesc

        // Identity image
        identityImageDisplayView.setImage(url: provider.identityImage)

        // Bank
        bankNameTextField.txtField.text = provider.bankInfo?.bankName
        bankAccountTextField.txtField.text = provider.bankInfo?.bankAccountNumber
        ibanTextField.txtField.text = provider.bankInfo?.iban

        applyHintColor()
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$profile
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                self?.setupProviderData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
}
