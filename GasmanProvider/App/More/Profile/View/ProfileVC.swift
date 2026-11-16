//
//  ProfileVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ProfileVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var profileImageView: ProfileImageView!

    // Personal Info
    @IBOutlet weak var firstNameTextField: GeneralTextField!
    @IBOutlet weak var lastNameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var identityTextField: GeneralTextField!
    @IBOutlet weak var identityEndDateTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: GeneralTextField!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var companyTextField: GeneralTextField!

    // Document Images
    @IBOutlet weak var vehicleOpLicenseView: ProfileImageDisplayView!
    @IBOutlet weak var vehicleRegView: ProfileImageDisplayView!
    @IBOutlet weak var identityImageView: ProfileImageDisplayView!
    @IBOutlet weak var drivingLicenseView: ProfileImageDisplayView!
    @IBOutlet weak var drivingLicenseEndDateTextField: GeneralTextField!
    @IBOutlet weak var vehicleInsuranceView: ProfileImageDisplayView!
    @IBOutlet weak var vehicleInsuranceEndDateTextField: GeneralTextField!
    @IBOutlet weak var carTypeTextField: GeneralTextField!

    // Vehicle Images
    @IBOutlet weak var vehicleFrontView: ProfileImageDisplayView!
    @IBOutlet weak var vehicleBackView: ProfileImageDisplayView!
    @IBOutlet weak var vehicleRightView: ProfileImageDisplayView!
    @IBOutlet weak var vehicleLeftView: ProfileImageDisplayView!

    // Extra Info
    @IBOutlet weak var vehicleSerialTextField: GeneralTextField!

    //MARK: - Properties -

    let viewModel: ProfileVM

    //MARK: - Initializer -

    init(viewModel: ProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProfileVC", bundle: nil)
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Life Cycle -

    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }

    //MARK: - Initial Setup -

    func initialConfiguration() {
        title = "profile".localized
        disableAllTextFields()
        setupUserData()
        viewModel.profileRequest()
        bindViewModel()
    }

    private func disableAllTextFields() {
        let textFields: [UIView] = [
            firstNameTextField, lastNameTextField, phoneTextField,
            emailTextField, identityTextField, identityEndDateTextField,
            cityTextField, locationTextField, companyTextField,
            drivingLicenseEndDateTextField, vehicleInsuranceEndDateTextField, carTypeTextField,
            vehicleSerialTextField
        ]

        textFields.forEach { $0.isUserInteractionEnabled = false }

        let hintFields: [UITextField] = [
            firstNameTextField.txtField, lastNameTextField.txtField,
            phoneTextField.txtField, emailTextField.txtField,
            identityTextField.txtField, identityEndDateTextField.txtField,
            cityTextField.txtField,
            locationTextField.txtField, companyTextField.txtField,
            drivingLicenseEndDateTextField.txtField, vehicleInsuranceEndDateTextField.txtField,
            carTypeTextField.txtField, vehicleSerialTextField.txtField
        ]
        hintFields.forEach { $0.textColor = .hint }
    }

    //MARK: - ViewModel Binding -

    private func bindViewModel() {
        viewModel.profile
            .sinkOnMain { [weak self] _ in
                self?.setupUserData()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    //MARK: - Setup Data -

    func setupUserData() {
        guard let user = Session.user else { return }

        // Profile image
        if let url = user.delegateImages?.first?.image {
            profileImageView.setImage(url: url)
        }
        profileImageView.cameraButton.isHidden = true

        // Name
        let parts = (user.name ?? "").split(separator: " ", maxSplits: 1)
        firstNameTextField.txtField.text = parts.first.map(String.init) ?? (user.name ?? "")
        lastNameTextField.txtField.text = parts.count > 1 ? String(parts[1]) : ""

        // Contact
        phoneTextField.txtField.text = user.phone ?? ""
        emailTextField.isHidden = (user.email?.trimWhiteSpace().isEmpty ?? true)
        emailTextField.txtField.text = user.email

        // Identity
        identityTextField.txtField.text = user.identityNumber
        identityEndDateTextField.txtField.text = user.delegateDates?.first?.identityNumberEndDate

        // Location
        cityTextField.txtField.text = user.city?.name
        locationTextField.txtField.text = user.mapDesc

        // Company
        companyTextField.txtField.text = user.type?.detailsText
        //companyTextField.isHidden = (user.delegateSource?.name?.isEmpty ?? true)

        // Document images
        let imgs = user.delegateImages?.first
        vehicleOpLicenseView.setImage(url: imgs?.vehicleOperatingLicenseImage)
        vehicleRegView.setImage(url: imgs?.vehicleRegistrationLicenseImage)
        identityImageView.setImage(url: imgs?.identityImage)
        drivingLicenseView.setImage(url: imgs?.drivingLicenseImage)
        drivingLicenseEndDateTextField.txtField.text = user.delegateDates?.first?.drivingLicenseEndDate
        vehicleInsuranceView.setImage(url: imgs?.vehicleInsuranceImage)
        vehicleInsuranceEndDateTextField.txtField.text = user.delegateDates?.first?.vehicleInsuranceEndDate
        carTypeTextField.txtField.text = user.carType?.name

        // Vehicle images
        vehicleFrontView.setImage(url: imgs?.vehicleFrontImage)
        vehicleBackView.setImage(url: imgs?.vehicleBackImage)
        vehicleRightView.setImage(url: imgs?.vehicleRightImage)
        vehicleLeftView.setImage(url: imgs?.vehicleLeftImage)

        // Serial
        vehicleSerialTextField.txtField.text = user.vehicleSerialNumber
    }
}
