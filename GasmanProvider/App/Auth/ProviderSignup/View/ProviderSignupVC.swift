//
//  ProviderSignupVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ProviderSignupVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var profileImage: ProfileImageView!
    @IBOutlet weak var storeNameTextField: GeneralTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var commercialNumberTextField: GeneralTextField!
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var identityImageView: DocumentPickerView!
    @IBOutlet weak var commercialImageView: DocumentPickerView!
    @IBOutlet weak var taxNumberTextField: GeneralTextField!
    @IBOutlet weak var establishmentNameTextField: GeneralTextField!
    @IBOutlet weak var commercialEndDateTextField: DatePickerField!
    @IBOutlet weak var permissionImageView: DocumentPickerView!
    @IBOutlet weak var permissionEndDateTextField: DatePickerField!
    @IBOutlet weak var bankNameTextField: GeneralTextField!
    @IBOutlet weak var bankAccountNumberTextField: GeneralTextField!
    @IBOutlet weak var ibanTextField: GeneralTextField!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var languageButton: IconTextGeneralButton!
    @IBOutlet weak var scrollView: UIScrollView!

    // MARK: - Properties -

    var viewModel: ProviderSignupVM
    override var navigationStyle: NavigationStyle { .white }

    // MARK: - Initializer -

    init(viewModel: ProviderSignupVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderSignupVC", bundle: nil)
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
        setupPickerDelegates()
        setupLocationField()
        setupDocumentPickerCallbacks()
        bindViewModel()
        setupChangeLanguage()
    }

    private func configureProfileImage() {
        profileImage.setCameraAction(target: self, action: #selector(onProfileCameraTap))
    }

    private func setupPickerDelegates() {
        cityTextField.delegate = self
    }

    private func setupLocationField() {
        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
    }

    private func setupDocumentPickerCallbacks() {
        identityImageView.onImagePicked = { [weak self] data in
            self?.viewModel.identityImageData = data
        }
        commercialImageView.onImagePicked = { [weak self] data in
            self?.viewModel.commercialImageData = data
        }
        permissionImageView.onImagePicked = { [weak self] data in
            self?.viewModel.permissionImageData = data
        }
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

    // MARK: - Picker -

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
        let emailText = emailTextField.txtField.text?.trimWhiteSpace()
        let email = (emailText?.isEmpty == false) ? emailText : nil

        let model = ProviderSignupModel(
            name: storeNameTextField.txtField.text,
            storeName: storeNameTextField.txtField.text,
            email: email,
            countryCode: "966",
            phone: phoneTextField.txtField.text,
            password: passwordTextField.txtField.text,
            passwordConfirmation: confirmPasswordTextField.txtField.text,
            commercialNumber: commercialNumberTextField.txtField.text,
            commercialEndDate: commercialEndDateTextField.dateText,
            taxNumber: taxNumberTextField.txtField.text,
            establishmentName: establishmentNameTextField.txtField.text,
            cityId: viewModel.selectedCity?.pickerId,
            lat: viewModel.selectedLat,
            lng: viewModel.selectedLng,
            mapDesc: viewModel.selectedMapDesc,
            permissionEndDate: permissionEndDateTextField.dateText,
            bankName: bankNameTextField.txtField.text,
            bankAccountNumber: bankAccountNumberTextField.txtField.text,
            iban: ibanTextField.txtField.text,
            imageData: viewModel.imageData,
            identityImageData: viewModel.identityImageData,
            commercialImageData: viewModel.commercialImageData,
            permissionImageData: viewModel.permissionImageData
        )
        viewModel.validate(model: model)
    }

    @objc func didTapChangeLanguage() {
        showLanguagePopup()
    }

    @objc func onLocationTapped() {
        goToSelectLocation()
    }

    @objc func onProfileCameraTap() {
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, data in
            guard let self, let data else { return }
            profileImage.setImage(image)
            viewModel.imageData = data
        }
    }
}

// MARK: - Routes -

extension ProviderSignupVC {
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

// MARK: - PickerFieldView Delegate -

extension ProviderSignupVC: PickerFieldViewDelegate {
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        if view == cityTextField {
            viewModel.citiesList.isEmpty ? viewModel.getCities() : showCityPicker()
        }
    }
}
