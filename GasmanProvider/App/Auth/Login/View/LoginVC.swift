//
//  LoginVC.swift
//  Esterad
//
//  Created by Haneen on 15/10/2025.
//

import UIKit
import Combine

class LoginVC: BaseViewController {

    //MARK: - Outlets -

    @IBOutlet weak var phoneTextField: PhoneTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var languageButton: IconTextGeneralButton!
    @IBOutlet weak var biometricContainerStack: UIStackView!
    @IBOutlet weak var faceIDButton: UIButton!
    @IBOutlet weak var touchIDButton: UIButton!
    
    //MARK: - Properties -
    
    let viewModel : LoginVM
    override var navigationStyle: NavigationStyle { .white }
    
    //MARK: - Initializer -
    
    init(viewModel : LoginVM){
        self.viewModel = viewModel
        super.init(nibName: "LoginVC", bundle: nil)
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
    
    func initialConfiguration(){
        bindViewModel()
        requestNotifications()
        setupChangeLanguage()
        setupBiometricButtons()
    }
    
    func setupChangeLanguage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapChangeLanguage))
        languageButton.addGestureRecognizer(tap)
        languageButton.buttonLabel.font = .systemFont(ofSize: 12)
    }

    private func setupBiometricButtons() {
        let biometricType = BiometricAuthHelper.biometricType

        let showFaceID  = biometricType == .faceID
        let showTouchID = biometricType == .touchID

        biometricContainerStack.isHidden = !showFaceID && !showTouchID
        faceIDButton.isHidden  = !showFaceID
        touchIDButton.isHidden = !showTouchID

        [faceIDButton, touchIDButton].forEach { button in
            button?.layer.cornerRadius = 25
            button?.clipsToBounds = true
            button?.backgroundColor = UIColor.systemGray6
            button?.tintColor = UIColor(named: "Main")
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
            button?.setPreferredSymbolConfiguration(config, forImageIn: .normal)
        }
    }

    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$login
            .dropFirst()
            .sinkOnMain{ [weak self] result in
                guard let self = self else { return }
                guard let result = result else { return }
                result.key == .needActive ? self.goToVerification() :self.goToHome()
            }
            .store(in: &cancellables)
        
        viewModel.$validationError
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
    
    private func requestNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
    }
    
    //MARK: - Action -
    
    @IBAction func didTapForgetPassword(_ sender: UIButton) {
        goToForgetPassword()
    }
    
    @IBAction func didTapLogin(_ sender: UIButton) {
        let phone = phoneTextField.txtField.text
        let password = passwordTextField.txtField.text
        viewModel.validateInputs(model: LoginModel(phone: phone, password: password))
    }
    
    @IBAction func didTapFaceID(_ sender: UIButton) {
        authenticateWithBiometrics()
    }

    @IBAction func didTapTouchID(_ sender: UIButton) {
        authenticateWithBiometrics()
    }
    
    @IBAction func didTapCreateAccount(_ sender: UIButton) {
        goToSignup()
    }
    
    @objc func didTapChangeLanguage() {
        showLanguagePopup()
    }

    private func authenticateWithBiometrics() {
        guard let credentials = KeychainHelper.loadCredentials() else {
            show(errorMessage: "biometric_login_no_credentials".localized)
            return
        }
        let reason = "biometric_login_hint".localized
        BiometricAuthHelper.authenticate(reason: reason) { [weak self] success, _ in
            guard let self = self, success else { return }
            self.viewModel.loginRequest(model: LoginModel(phone: credentials.phone,
                                                          password: credentials.password))
        }
    }
}

//MARK: - Routes -

extension LoginVC {
    func showLanguagePopup(){
        let vc = LanguagePopUp()
        vc.appear(sender: self)
    }
    
    func goToSignup(){
        if Session.userType == .serviceProvider {
            let vc = ProviderSignupVC(viewModel: ProviderSignupVM())
            push(vc)
        } else {
            let vc = SignupVC(viewModel: SignupVM())
            push(vc)
        }
    }
    
    func goToForgetPassword(){
        let vc = ForgetPasswordVC(viewModel: ForgetPasswordVM())
        push(vc)
    }
    
    func goToHome() {
        UserDefaults.isLogin = true
        let vc: UIViewController = Session.userType == .serviceProvider
            ? ProviderTabBarController.create()
            : AppTabBarController.create()
        AppHelper.changeWindowRoot(vc: vc)
    }
    
    func goToVerification(){
        guard let phone = phoneTextField.txtField.text else { return }
        let vc = VerificationVC(viewModel: VerificationVM(phone: phone))
        push(vc)
    }
}
