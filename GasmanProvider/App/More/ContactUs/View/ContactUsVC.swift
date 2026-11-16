//
//  ContactUsVC.swift
//  Esterad
//
//  Created by Haneen on 09/11/2025.
//

import UIKit
import Combine

class ContactUsVC: BaseViewController {
    
    //MARK: - Outlets -

    @IBOutlet weak var contactAdminLabel: UILabel!
    @IBOutlet weak var usernameTextField: GeneralTextField!
    @IBOutlet weak var emailTextFiled: GeneralTextField!
    @IBOutlet weak var detailsTextView: DropDownTextView!
    @IBOutlet weak var imagesView: ComplaintImagesView!
    
    //MARK: - Properties -
    
    let viewModel : ContactUsVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : ContactUsVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "ContactUsVC", bundle: nil)
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
    
    func initialConfiguration() {
        self.title = "contact_us".localized
        bindViewModel()
        viewModel.fetchContactUsData()
    }

    //MARK: - Action -

    @IBAction func didTapSend(_ sender: UIButton) {
      let model = ContactUsModel(
        name: usernameTextField.txtField.text,
        email: emailTextFiled.txtField.text,
        subject: detailsTextView.actualText,
        images: imagesView.imagesList.map {$0.data}
      )
        viewModel.validateInputs(model: model)
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        
        loading(viewModel.isLoadingPublisher)
        
        viewModel.contactUsDataPublisher
            .compactMap { $0?.data?.phone }
            .sinkOnMain { [weak self] phone in
                guard let self = self else { return }
                contactAdminLabel.text = String(format: "contact_admin_message".localized, phone)
            }
            .store(in: &cancellables)

        viewModel.contactUsPublisher
            .dropFirst()
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                showPopup(title : result?.message ?? "")
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .compactMap{ $0 }
            .sinkOnMain{ [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)
                
        error(viewModel.errorPublisher)
    }
}

//MARK: - Routes -

extension ContactUsVC {
    func showPopup(title : String){
        let vc = LottiePopup()
        vc.appear(sender: self)
        vc.setupView(title: title)
        vc.onPopupHidden = { [weak self] in
            guard let self = self else { return }
            pop()
        }
    }
}
