//
//  ProviderUpdateProfileVC.swift
//  GasmanProvider
//

import UIKit
import Combine

class ProviderUpdateProfileVC: BaseViewController {

    // MARK: - Outlets -

    @IBOutlet weak var profileImageView: ProfileImageView!
    @IBOutlet weak var storeNameTextField: GeneralTextField!
    @IBOutlet weak var emailTextField: GeneralTextField!
    @IBOutlet weak var commercialNumberTextField: GeneralTextField!
    @IBOutlet weak var commercialEndDateTextField: DatePickerField!
    @IBOutlet weak var cityTextField: PickerFieldView!
    @IBOutlet weak var locationTextField: GeneralTextField!
    @IBOutlet weak var identityImagePickerView: DocumentPickerView!
    @IBOutlet weak var bankNameTextField: GeneralTextField!
    @IBOutlet weak var bankAccountTextField: GeneralTextField!
    @IBOutlet weak var ibanTextField: GeneralTextField!

    // MARK: - Properties -

    var viewModel: ProviderUpdateProfileVM

    // MARK: - Initializer -

    init(viewModel: ProviderUpdateProfileVM) {
        self.viewModel = viewModel
        super.init(nibName: "ProviderUpdateProfileVC", bundle: nil)
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
        cityTextField.delegate = self
    }

    private func setupLocationField() {
        locationTextField.txtField.isEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(onLocationTapped))
        locationTextField.addGestureRecognizer(tap)
    }

    private func setupDocumentPickerCallbacks() {
        identityImagePickerView.onImagePicked = { [weak self] data in
            self?.viewModel.identityImageData = data
        }
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

        // Email
        emailTextField.txtField.text = nil

        // Commercial
        commercialNumberTextField.txtField.text = provider.commercialNumber
        commercialEndDateTextField.txtField.text = provider.commercialEndDate

        // City
        viewModel.selectedCity = provider.city
        cityTextField.txtField.text = provider.city?.name

        // Location
        viewModel.selectedLat = provider.lat
        viewModel.selectedLng = provider.lng
        viewModel.selectedMapDesc = provider.mapDesc
        locationTextField.txtField.text = provider.mapDesc

        // Identity image
        identityImagePickerView.setImage(url: provider.identityImage)

        // Bank
        bankNameTextField.txtField.text = provider.bankInfo?.bankName
        bankAccountTextField.txtField.text = provider.bankInfo?.bankAccountNumber
        ibanTextField.txtField.text = provider.bankInfo?.iban
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

    // MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$profile
            .compactMap { $0 }
            .sinkOnMain { [weak self] _ in
                self?.setupProviderData()
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

        error(viewModel.$error)
    }

    // MARK: - Actions -

    @IBAction func didTapSave(_ sender: UIButton) {
        let emailText = emailTextField.txtField.text?.trimWhiteSpace()
        let email = (emailText?.isEmpty == false) ? emailText : nil
        let model = UpdateProviderProfileModel(
            name: storeNameTextField.txtField.text,
            storeName: storeNameTextField.txtField.text,
            email: email,
            commercialNumber: commercialNumberTextField.txtField.text,
            commercialEndDate: commercialEndDateTextField.dateText,
            cityId: viewModel.selectedCity?.pickerId,
            lat: viewModel.selectedLat,
            lng: viewModel.selectedLng,
            mapDesc: viewModel.selectedMapDesc,
            permissionEndDate: nil,
            bankName: bankNameTextField.txtField.text,
            bankAccountNumber: bankAccountTextField.txtField.text,
            iban: ibanTextField.txtField.text,
            imageData: viewModel.imageData,
            commercialImageData: viewModel.commercialImageData,
            permissionImageData: viewModel.permissionImageData,
            identityImageData: viewModel.identityImageData
        )
        viewModel.validateAndUpdate(model: model)
    }

    @objc func onProfileCameraTap() {
        let picker = ImagePicker()
        picker.pickImage { [weak self] image, data in
            guard let self, let data else { return }
            profileImageView.setImage(image)
            viewModel.imageData = data
        }
    }

    @objc func onLocationTapped() {
        goToSelectLocation()
    }
}

// MARK: - PickerFieldView Delegate -

extension ProviderUpdateProfileVC: PickerFieldViewDelegate {
    func pickerFieldViewDidTap(_ view: PickerFieldView) {
        if view == cityTextField {
            viewModel.citiesList.isEmpty ? viewModel.getCities() : showCityPicker()
        }
    }
}

// MARK: - Routes -

extension ProviderUpdateProfileVC {
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
        if let lat = viewModel.selectedLat, let lng = viewModel.selectedLng {
            vm.initialLocation = AddressModel(lat: lat, long: lng, desc: viewModel.selectedMapDesc ?? "")
        }
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
