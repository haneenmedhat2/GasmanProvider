//
//  SignupVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class SignupVC: BaseViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    
    // Personal Info
    @IBOutlet weak var firstNameTextField: GeneralTextField!
    @IBOutlet weak var lastNameTextField: GeneralTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var relatedMerchantTextField: PickerFieldView!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var identityNumberTextField: GeneralTextField!

    // Location
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var locationTextField: GeneralTextField!
    
    // Vehicle
    @IBOutlet weak var vehicleLicensePlateTextField: GeneralTextField!
    @IBOutlet weak var vehicleSerialNumberTextField: GeneralTextField!
    @IBOutlet weak var carTypeTextField: PickerFieldView!
    @IBOutlet weak var carModelTextField: PickerFieldView!
    // Document Images
    @IBOutlet weak var driverIdentityImageView: DocumentPickerView!
    @IBOutlet weak var driverIdentityEndDateTextField: DatePickerField!
    @IBOutlet weak var vehicleOperatingLicenseImageView: DocumentPickerView!
    @IBOutlet weak var vehicleOperatingLicenseEndDateTextField: DatePickerField!
    @IBOutlet weak var identityImageView: DocumentPickerView!
    @IBOutlet weak var identityImageEndDateTextField: DatePickerField!
    @IBOutlet weak var vehicleRegistrationLicenseImageView: DocumentPickerView!
    @IBOutlet weak var vehicleRegistrationLicenseDateTextField: DatePickerField!
    @IBOutlet weak var drivingLicenseImageView: DocumentPickerView!
    @IBOutlet weak var drivingLicenseEndDateTextField: DatePickerField!
    @IBOutlet weak var vehicleInsuranceImageView: DocumentPickerView!
    @IBOutlet weak var vehicleInsuranceEndDateTextField: DatePickerField!
    @IBOutlet weak var periodicCheckUpImageView: DocumentPickerView!
    @IBOutlet weak var periodicCheckUpDateTextField: DatePickerField!

    // Other
    @IBOutlet weak var otherImageView: DocumentPickerView!

    // Vehicle Photos
    @IBOutlet weak var vehicleFrontImageView: DocumentPickerView!
    @IBOutlet weak var vehicleBackImageView: DocumentPickerView!
    @IBOutlet weak var vehicleRightImageView: DocumentPickerView!
    @IBOutlet weak var vehicleLeftImageView: DocumentPickerView!
    
    // Footer
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var languageButton: IconTextGeneralButton!
    @IBOutlet weak var termsStackView: UIStackView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - Properties -

    var viewModel: SignupVM
    override var navigationStyle: NavigationStyle { .white }

    private var selectedTypeIndex = 0
    private var currentStep = 0

    private var step0Views: [UIView] {
        [firstNameTextField, lastNameTextField, phoneTextField,
         relatedMerchantTextField,
         passwordTextField, confirmPasswordTextField, emailTextField,
         identityNumberTextField, cityTextField,
         locationTextField, carTypeTextField, carModelTextField,
         vehicleLicensePlateTextField]
    }
    private var step1Views: [UIView] {
        [vehicleSerialNumberTextField,
         driverIdentityImageView, driverIdentityEndDateTextField,
         vehicleOperatingLicenseImageView, vehicleOperatingLicenseEndDateTextField,
         identityImageView, identityImageEndDateTextField,
         drivingLicenseImageView, drivingLicenseEndDateTextField,
         vehicleRegistrationLicenseImageView, vehicleRegistrationLicenseDateTextField,
         vehicleInsuranceImageView]
    }
    private var step2Views: [UIView] {
        [vehicleInsuranceEndDateTextField,
         periodicCheckUpImageView, periodicCheckUpDateTextField,
         otherImageView,
         vehicleFrontImageView, vehicleBackImageView,
         vehicleRightImageView, vehicleLeftImageView]
    }
    
    // MARK: - Initializer -
    
    init(viewModel: SignupVM) {
        self.viewModel = viewModel
        super.init(nibName: "SignupVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
    }
    
    // MARK: - Setup -
    
    func initialConfiguration() {
        configureProfileImage()
        configureTypeCollectionView()
        setupPickerDelegates()
        setupLocationField()
        setupDocumentPickerCallbacks()
        bindViewModel()
        setupChangeLanguage()
        setupBackButton()
        updateStepUI()
    }

    private func setupBackButton() {
        let image = Language.isRTL()
            ? UIImage(resource: .backBtn).withRenderingMode(.alwaysOriginal)
            : UIImage(resource: .backBtnAr).withRenderingMode(.alwaysOriginal)

        let button = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(onBackTapped)
        )

        navigationItem.leftBarButtonItem = button
    }
    
    @objc private func onBackTapped() {
        if currentStep > 0 {
            currentStep -= 1
            updateStepUI()
            scrollView.setContentOffset(.zero, animated: false)
        } else {
            pop()
        }
    }

    private func updateStepUI() {
        (step0Views + step1Views + step2Views).forEach { $0.isHidden = true }
        switch currentStep {
        case 0:
            step0Views.forEach { $0.isHidden = false }
        case 1:
            step1Views.forEach { $0.isHidden = false }
        case 2:
            step2Views.forEach { $0.isHidden = false }
        default: break
        }
        termsStackView.isHidden = currentStep == 0
        let isLastStep = currentStep == 2
        confirmButton.setTitle(isLastStep ? "create_account".localized : "next".localized, for: .normal)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = currentStep == 0
    }

    private func goToNextStep() {
        guard currentStep < 2 else { return }
        currentStep += 1
        updateStepUI()
        scrollView.setContentOffset(.zero, animated: false)
    }
    
    private func configureProfileImage() {
        profileImage.setCameraAction(target: self, action: #selector(onProfileCameraTap))
    }
    
    private func setupDocumentPickerCallbacks() {
        let configs: [(DocumentPickerView, String, (String?) -> Void)] = [
            (identityImageView, "identity_image", { [weak self] url in self?.viewModel.identityImage = url }),
            (driverIdentityImageView, "driver_identity_image", { [weak self] url in self?.viewModel.driverIdentityImage = url }),
            (vehicleOperatingLicenseImageView, "vehicle_operating_license_image", { [weak self] url in self?.viewModel.vehicleOperatingLicenseImage = url }),
            (drivingLicenseImageView, "driving_license_image", { [weak self] url in self?.viewModel.drivingLicenseImage = url }),
            (vehicleRegistrationLicenseImageView, "vehicle_registration_license_image", { [weak self] url in self?.viewModel.vehicleRegistrationLicenseImage = url }),
            (vehicleInsuranceImageView, "vehicle_insurance_image", { [weak self] url in self?.viewModel.vehicleInsuranceImage = url }),
            (periodicCheckUpImageView, "periodic_check_up_image", { [weak self] url in self?.viewModel.periodicCheckUpImage = url }),
            (otherImageView, "other_image", { [weak self] url in self?.viewModel.otherImage = url }),
            (vehicleFrontImageView, "vehicle_front_image", { [weak self] url in self?.viewModel.vehicleFrontImage = url }),
            (vehicleBackImageView, "vehicle_back_image", { [weak self] url in self?.viewModel.vehicleBackImage = url }),
            (vehicleRightImageView, "vehicle_right_image", { [weak self] url in self?.viewModel.vehicleRightImage = url }),
            (vehicleLeftImageView, "vehicle_left_image", { [weak self] url in self?.viewModel.vehicleLeftImage = url }),
        ]
        for (picker, imageType, store) in configs {
            picker.onImagePicked = { [weak self] data in
                guard let self else { return }
                viewModel.uploadImage(data: data, imageType: imageType, completion: store)
            }
        }
    }

    private func setupPickerDelegates() {
        [cityTextField, relatedMerchantTextField,
         carTypeTextField, carModelTextField].forEach { $0?.delegate = self }
    }

    private func setupLocationField() {
        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
    }
    
    func setupChangeLanguage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChangeLanguage))
        languageButton.addGestureRecognizer(tap)
        languageButton.buttonLabel.font = .systemFont(ofSize: 12)
    }
    
    // MARK: - Checkbox -
    
    private func updateCheckboxAppearance() {
        viewModel.isChecked.toggle()
        let name = viewModel.isChecked ? "checkmark.square" : "square"
        checkBoxButton.setImage(UIImage(systemName: name), for: .normal)
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

    private func showRelatedMerchantPicker() {
        let popup = PickerListPopup()
        popup.allowMultipleSelection = false
        popup.pickerList = viewModel.providersList
        popup.selectedItem = viewModel.selectedProvider
        popup.onItemSelected = { [weak self] item in
            guard let self else { return }
            viewModel.selectedProvider = item
            relatedMerchantTextField.txtField.text = item?.pickerName
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
        
        viewModel.$signup
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.goToVerification()
            }
            .store(in: &cancellables)
        
        viewModel.$validation
            .compactMap { $0 }
            .sinkOnMain { [weak self] err in
                self?.show(errorMessage: err.localizedDescription)
            }
            .store(in: &cancellables)
        
        viewModel.$citiesList
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.showCityPicker()
            }
            .store(in: &cancellables)

        viewModel.$providersList
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.showRelatedMerchantPicker()
            }
            .store(in: &cancellables)

        viewModel.$carTypesList
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.showCarTypePicker()
            }
            .store(in: &cancellables)

        viewModel.$carModelsList
            .dropFirst()
            .sinkOnMain { [weak self] _ in
                self?.showCarModelPicker()
            }
            .store(in: &cancellables)

        viewModel.stepValidatedSubject
            .sinkOnMain { [weak self] in
                self?.goToNextStep()
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
    
    // MARK: - Actions -
    
    @IBAction func didTapCheckBox(_ sender: UIButton) {
        updateCheckboxAppearance()
    }
    
    @IBAction func didTapTermsAndConditions(_ sender: UIButton) {
        goToTermsAndConditions()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        goToLogin()
    }
    
    @IBAction func didTapConfirm(_ sender: UIButton) {
        viewModel.validate(step: currentStep, model: buildSignupModel())
    }

    private func buildSignupModel() -> SignupModel {
        let emailText = emailTextField.txtField.text?.trimWhiteSpace()
        let email = (emailText?.isEmpty == false) ? emailText : nil
        let typeValue = viewModel.typeOptionsList.indices.contains(selectedTypeIndex)
            ? Int(viewModel.typeOptionsList[selectedTypeIndex].apiValue)
            : nil
        return SignupModel(
            firstName: firstNameTextField.txtField.text,
            lastName: lastNameTextField.txtField.text,
            countryCode: "966",
            phone: phoneTextField.txtField.text,
            email: email,
            password: passwordTextField.txtField.text,
            passwordConfirmation: confirmPasswordTextField.txtField.text,
            identityNumber: identityNumberTextField.txtField.text,
            type: typeValue,
            cityId: viewModel.selectedCity?.pickerId,
            providerId: viewModel.selectedProvider?.pickerId,
            carTypeId: viewModel.selectedCarType?.pickerId,
            carModelId: viewModel.selectedCarModel?.pickerId,
            vehicleLicensePlate: vehicleLicensePlateTextField.txtField.text,
            vehicleSerialNumber: vehicleSerialNumberTextField.txtField.text,
            lat: viewModel.selectedLat,
            lng: viewModel.selectedLng,
            mapDesc: viewModel.selectedMapDesc,
            lang: Language.apiLanguage(),
            identityNumberEndDate: identityImageEndDateTextField.dateText,
            driverIdentityEndDate: driverIdentityEndDateTextField.dateText,
            vehicleOperatingLicenseEndDate: vehicleOperatingLicenseEndDateTextField.dateText,
            identityImageEndDate: identityImageEndDateTextField.dateText,
            vehicleRegistrationLicenseDate: vehicleRegistrationLicenseDateTextField.dateText,
            drivingLicenseEndDate: drivingLicenseEndDateTextField.dateText,
            vehicleInsuranceEndDate: vehicleInsuranceEndDateTextField.dateText,
            periodicCheckUpDate: periodicCheckUpDateTextField.dateText,
            image: viewModel.image,
            identityImage: viewModel.identityImage,
            driverIdentityImage: viewModel.driverIdentityImage,
            vehicleOperatingLicenseImage: viewModel.vehicleOperatingLicenseImage,
            drivingLicenseImage: viewModel.drivingLicenseImage,
            vehicleRegistrationLicenseImage: viewModel.vehicleRegistrationLicenseImage,
            vehicleInsuranceImage: viewModel.vehicleInsuranceImage,
            periodicCheckUpImage: viewModel.periodicCheckUpImage,
            otherImage: viewModel.otherImage,
            vehicleFrontImage: viewModel.vehicleFrontImage,
            vehicleBackImage: viewModel.vehicleBackImage,
            vehicleRightImage: viewModel.vehicleRightImage,
            vehicleLeftImage: viewModel.vehicleLeftImage
        )
    }
    
    @objc func didTapChangeLanguage() {
        showLanguagePopup()
    }
    
    @objc func onLocationTapped(){
        goToSelectLocation()
    }
    
    @objc func onProfileCameraTap() {
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, data in
            guard let self, let data else { return }
            profileImage.setImage(image)
            viewModel.uploadImage(data: data, imageType: "image") { [weak self] url in
                self?.viewModel.image = url
            }
        }
    }
}

// MARK: - Routes -

extension SignupVC {
    func showLanguagePopup() {
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func goToLogin() {
        popToRoot()
    }
    
    func goToVerification() {
        guard let phone = phoneTextField.txtField.text else { return }
        let vc = VerificationVC(viewModel: VerificationVM(phone: phone))
        push(vc)
    }
    
    func goToTermsAndConditions() {
        let vc = TermsAndConditionsVC(viewModel: TermsAndConditionsVM())
        vc.hidesBottomBarWhenPushed = true
        push(vc)
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

// MARK: - Type CollectionView -

extension SignupVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureTypeCollectionView() {
        typeCollectionView.register(cellType: SelectableOptionCell.self)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.typeOptionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SelectableOptionCell.self, for: indexPath)
        let item = viewModel.typeOptionsList[indexPath.row]
        cell.setupCell(model:item , isSelected: selectedTypeIndex == indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard selectedTypeIndex != indexPath.row else { return }
        selectedTypeIndex = indexPath.row
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {

        let totalSpacing: CGFloat = 8
        let width = (collectionView.frame.width - totalSpacing) / 2
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return  8
    }
}

// MARK: - PickerFieldView Delegate -

extension SignupVC: PickerFieldViewDelegate {
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        switch view {
        case cityTextField:
            viewModel.citiesList.isEmpty ? viewModel.getCities() : showCityPicker()
        case relatedMerchantTextField:
            viewModel.providersList.isEmpty ? viewModel.getProviders() : showRelatedMerchantPicker()
        case carTypeTextField:
            viewModel.carTypesList.isEmpty ? viewModel.getCarTypes() : showCarTypePicker()
        case carModelTextField:
            guard let carTypeId = viewModel.selectedCarType?.pickerId  else { return }
            viewModel.carModelsList.isEmpty ? viewModel.getCarModels(carTypeId: carTypeId) : showCarModelPicker()
        default:
            break
        }
    }
}
