//
//  UpdateProfileVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class UpdateProfileVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var profileImageView: ProfileImageView!

    // Personal Info
    @IBOutlet weak var firstNameTextField: GeneralTextField!
    @IBOutlet weak var lastNameTextField: GeneralTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var identityTextField: GeneralTextField!
    @IBOutlet weak var identityEndDateTextField: DatePickerField!

    // Location
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var locationTextField: GeneralTextField!

    // Document Images
    @IBOutlet weak var vehicleOpLicensePickerView: DocumentPickerView!
    @IBOutlet weak var vehicleRegPickerView: DocumentPickerView!
    @IBOutlet weak var identityImagePickerView: DocumentPickerView!
    @IBOutlet weak var drivingLicensePickerView: DocumentPickerView!
    @IBOutlet weak var drivingLicenseEndDateTextField: DatePickerField!
    @IBOutlet weak var vehicleInsurancePickerView: DocumentPickerView!
    @IBOutlet weak var vehicleInsuranceEndDateTextField: DatePickerField!

    // Vehicle
    @IBOutlet weak var carTypeTextField: PickerFieldView!
    @IBOutlet weak var carModelTextField: PickerFieldView!
    @IBOutlet weak var vehicleFrontPickerView: DocumentPickerView!
    @IBOutlet weak var vehicleBackPickerView: DocumentPickerView!
    @IBOutlet weak var vehicleRightPickerView: DocumentPickerView!
    @IBOutlet weak var vehicleLeftPickerView: DocumentPickerView!
    @IBOutlet weak var vehicleSerialTextField: GeneralTextField!
    @IBOutlet weak var vehicleLicensePlate: GeneralTextField!

    // MARK: - Properties -

    var viewModel: UpdateProfileVM

    // MARK: - Initializer -

    init(viewModel: UpdateProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: "UpdateProfileVC", bundle: nil)
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
        self.title = "edit_profile".localized
        configureProfileImage()
        setupPickerDelegates()
        setupLocationField()
        setupDocumentPickerCallbacks()
        bindViewModel()
        viewModel.profileRequest()
    }

    private func configureProfileImage() {
        profileImageView.setCameraAction(target: self, action: #selector(onProfileCameraTap))
    }

    private func setupPickerDelegates() {
        [cityTextField, carTypeTextField, carModelTextField].forEach { $0?.delegate = self }
    }

    private func setupLocationField() {
        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
    }

    private func setupDocumentPickerCallbacks() {
        let configs: [(DocumentPickerView, String, (String?) -> Void)] = [
            (vehicleOpLicensePickerView, "vehicle_operating_license_image", { [weak self] url in self?.viewModel.vehicleOperatingLicenseImage = url }),
            (vehicleRegPickerView, "vehicle_registration_license_image", { [weak self] url in self?.viewModel.vehicleRegistrationLicenseImage = url }),
            (identityImagePickerView, "identity_image", { [weak self] url in self?.viewModel.identityImage = url }),
            (drivingLicensePickerView, "driving_license_image", { [weak self] url in self?.viewModel.drivingLicenseImage = url }),
            (vehicleInsurancePickerView, "vehicle_insurance_image", { [weak self] url in self?.viewModel.vehicleInsuranceImage = url }),
            (vehicleFrontPickerView, "vehicle_front_image", { [weak self] url in self?.viewModel.vehicleFrontImage = url }),
            (vehicleBackPickerView, "vehicle_back_image", { [weak self] url in self?.viewModel.vehicleBackImage = url }),
            (vehicleRightPickerView, "vehicle_right_image", { [weak self] url in self?.viewModel.vehicleRightImage = url }),
            (vehicleLeftPickerView, "vehicle_left_image", { [weak self] url in self?.viewModel.vehicleLeftImage = url }),
        ]
        for (picker, imageType, store) in configs {
            picker.onImagePicked = { [weak self] data in
                guard let self else { return }
                viewModel.uploadImage(data: data, imageType: imageType, completion: store)
            }
        }
    }

    // MARK: - Data Pre-population -

    func setupUserData() {
        guard let user = Session.user else { return }

        // Profile image
        if let url = user.delegateImages?.first?.image {
            profileImageView.setImage(url: url)
        }
        // Name
        let parts = (user.name ?? "").split(separator: " ", maxSplits: 1)
        firstNameTextField.txtField.text = parts.first.map(String.init) ?? ""
        lastNameTextField.txtField.text = parts.count > 1 ? String(parts[1]) : ""

        // Contact
        emailTextField.txtField.text = user.email

        // Identity
        identityTextField.txtField.text = user.identityNumber

        // Dates
        let dates = user.delegateDates?.first
        identityEndDateTextField.txtField.text = dates?.identityNumberEndDate
        drivingLicenseEndDateTextField.txtField.text = dates?.drivingLicenseEndDate
        vehicleInsuranceEndDateTextField.txtField.text = dates?.vehicleInsuranceEndDate

        // City
        viewModel.selectedCity = user.city
        cityTextField.txtField.text = user.city?.name

        // Location
        viewModel.selectedLat = user.lat
        viewModel.selectedLng = user.lng
        viewModel.selectedMapDesc = user.mapDesc
        locationTextField.txtField.text = user.mapDesc

        // Car type
        viewModel.selectedCarType = user.carType
        carTypeTextField.txtField.text = user.carType?.name

        // Car model
        viewModel.selectedCarModel = user.carModel
        carModelTextField.txtField.text = user.carModel?.name

        // Vehicle
        vehicleSerialTextField.txtField.text = user.vehicleSerialNumber
        vehicleLicensePlate.txtField.text = user.vehicleLicensePlate

        // Pre-populate image filenames in VM (so unchanged images are still sent).
        // Server returns full URLs but the endpoint expects only the filename.
        let imgs = user.delegateImages?.first
        viewModel.image = Self.filename(from: imgs?.image)
        viewModel.identityImage = Self.filename(from: imgs?.identityImage)
        viewModel.vehicleOperatingLicenseImage = Self.filename(from: imgs?.vehicleOperatingLicenseImage)
        viewModel.drivingLicenseImage = Self.filename(from: imgs?.drivingLicenseImage)
        viewModel.vehicleRegistrationLicenseImage = Self.filename(from: imgs?.vehicleRegistrationLicenseImage)
        viewModel.vehicleInsuranceImage = Self.filename(from: imgs?.vehicleInsuranceImage)
        viewModel.vehicleFrontImage = Self.filename(from: imgs?.vehicleFrontImage)
        viewModel.vehicleBackImage = Self.filename(from: imgs?.vehicleBackImage)
        viewModel.vehicleRightImage = Self.filename(from: imgs?.vehicleRightImage)
        viewModel.vehicleLeftImage = Self.filename(from: imgs?.vehicleLeftImage)

        // Pre-populate document picker views with existing images
        vehicleOpLicensePickerView.setImage(url: imgs?.vehicleOperatingLicenseImage)
        vehicleRegPickerView.setImage(url: imgs?.vehicleRegistrationLicenseImage)
        identityImagePickerView.setImage(url: imgs?.identityImage)
        drivingLicensePickerView.setImage(url: imgs?.drivingLicenseImage)
        vehicleInsurancePickerView.setImage(url: imgs?.vehicleInsuranceImage)
        vehicleFrontPickerView.setImage(url: imgs?.vehicleFrontImage)
        vehicleBackPickerView.setImage(url: imgs?.vehicleBackImage)
        vehicleRightPickerView.setImage(url: imgs?.vehicleRightImage)
        vehicleLeftPickerView.setImage(url: imgs?.vehicleLeftImage)
    }

    // MARK: - Picker Popups -

    private func showCityPicker() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.citiesList
        popup.selectedItem = viewModel.selectedCity
        popup.onItemSelected = { [weak self] item in
            guard let self else { return }
            viewModel.selectedCity = item
            cityTextField.txtField.text = item?.pickerName
        }
        popup.appear(sender: self)
    }

    private func showCarTypePicker() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.carTypesList
        popup.selectedItem = viewModel.selectedCarType
        popup.onItemSelected = { [weak self] item in
            guard let self else { return }
            viewModel.selectedCarType = item
            carTypeTextField.txtField.text = item?.pickerName
            viewModel.selectedCarModel = nil
            carModelTextField.txtField.text = nil
            viewModel.carModelsList = []
        }
        popup.appear(sender: self)
    }

    private func showCarModelPicker() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.carModelsList
        popup.selectedItem = viewModel.selectedCarModel
        popup.onItemSelected = { [weak self] item in
            guard let self else { return }
            viewModel.selectedCarModel = item
            carModelTextField.txtField.text = item?.pickerName
        }
        popup.appear(sender: self)
    }

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$profile
            .sinkOnMain { [weak self] _ in
                self?.setupUserData()
            }
            .store(in: &cancellables)

        viewModel.$updateProfile
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self else { return }
                showPopup(title: result?.message ?? "")
            }
            .store(in: &cancellables)

        viewModel.$validation
            .compactMap { $0 }
            .sinkOnMain { [weak self] error in
                self?.show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)

        viewModel.$citiesList
            .dropFirst()
            .sinkOnMain { [weak self] _ in self?.showCityPicker() }
            .store(in: &cancellables)

        viewModel.$carTypesList
            .dropFirst()
            .sinkOnMain { [weak self] _ in self?.showCarTypePicker() }
            .store(in: &cancellables)

        viewModel.$carModelsList
            .dropFirst()
            .sinkOnMain { [weak self] _ in self?.showCarModelPicker() }
            .store(in: &cancellables)

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapSave(_ sender: UIButton) {
        viewModel.validateAndUpdate(model: buildUpdateProfileModel())
    }

    private func buildUpdateProfileModel() -> UpdateProfileModel {
        let emailText = emailTextField.txtField.text?.trimWhiteSpace()
        let email = (emailText?.isEmpty == false) ? emailText : nil
        return UpdateProfileModel(
            firstName: firstNameTextField.txtField.text,
            lastName: lastNameTextField.txtField.text,
            email: email,
            identityNumber: identityTextField.txtField.text,
            cityId: viewModel.selectedCity?.pickerId,
            carTypeId: viewModel.selectedCarType?.pickerId,
            carModelId: viewModel.selectedCarModel?.pickerId,
            vehicleLicensePlate: vehicleLicensePlate.txtField.text,
            vehicleSerialNumber: vehicleSerialTextField.txtField.text,
            lat: viewModel.selectedLat,
            lng: viewModel.selectedLng,
            mapDesc: viewModel.selectedMapDesc,
            identityNumberEndDate: identityEndDateTextField.dateText,
            driverIdentityEndDate: nil,
            vehicleOperatingLicenseEndDate: nil,
            identityImageEndDate: nil,
            vehicleRegistrationLicenseDate: nil,
            drivingLicenseEndDate: drivingLicenseEndDateTextField.dateText,
            vehicleInsuranceEndDate: vehicleInsuranceEndDateTextField.dateText,
            periodicCheckUpDate: nil,
            image: viewModel.image,
            identityImage: viewModel.identityImage,
            driverIdentityImage: nil,
            vehicleOperatingLicenseImage: viewModel.vehicleOperatingLicenseImage,
            drivingLicenseImage: viewModel.drivingLicenseImage,
            vehicleRegistrationLicenseImage: viewModel.vehicleRegistrationLicenseImage,
            vehicleInsuranceImage: viewModel.vehicleInsuranceImage,
            periodicCheckUpImage: nil,
            otherImage: nil,
            vehicleFrontImage: viewModel.vehicleFrontImage,
            vehicleBackImage: viewModel.vehicleBackImage,
            vehicleRightImage: viewModel.vehicleRightImage,
            vehicleLeftImage: viewModel.vehicleLeftImage
        )
    }

    @objc func onProfileCameraTap() {
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, data in
            guard let self, let data else { return }
            profileImageView.setImage(image)
            viewModel.uploadImage(data: data, imageType: "image") { [weak self] url in
                self?.viewModel.image = url
            }
        }
    }

    @objc func onLocationTapped() {
        goToSelectLocation()
    }

    private static func filename(from urlOrName: String?) -> String? {
        guard let value = urlOrName?.trimWhiteSpace(), !value.isEmpty else { return nil }
        if let last = URL(string: value)?.lastPathComponent, !last.isEmpty {
            return last
        }
        return value
    }
}

// MARK: - PickerFieldView Delegate -

extension UpdateProfileVC: PickerFieldViewDelegate {
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        switch view {
        case cityTextField:
            viewModel.citiesList.isEmpty ? viewModel.getCities() : showCityPicker()
        case carTypeTextField:
            viewModel.carTypesList.isEmpty ? viewModel.getCarTypes() : showCarTypePicker()
        case carModelTextField:
            guard let carTypeId = viewModel.selectedCarType?.pickerId else { return }
            viewModel.carModelsList.isEmpty ? viewModel.getCarModels(carTypeId: carTypeId) : showCarModelPicker()
        default:
            break
        }
    }
}

// MARK: - Routes -

extension UpdateProfileVC {
    func showPopup(title: String) {
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            self?.pop()
        }
    }

    func goToSelectLocation() {
        let vm = SelectLocationVM()
        let vc = SelectLocationVC(viewModel: vm)
        vm.onLocationSelected = { [weak self] address in
            guard let self else { return }
            viewModel.selectedLat = address.lat
            viewModel.selectedLng = address.long
            viewModel.selectedMapDesc = address.desc
            locationTextField.txtField.text = address.desc
        }
        push(vc)
    }
}
