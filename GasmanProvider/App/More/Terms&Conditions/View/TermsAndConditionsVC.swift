//
//  TermsAndConditionsVC.swift
//  Esterad
//
//  Created by Haneen on 10/11/2025.
//

import UIKit
import Combine

class TermsAndConditionsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var staticPagesView: StaticPagesView!
    
    //MARK: - Properties -
    
    var viewModel : TermsAndConditionsVM
    
    //MARK: - Initializer -
    
    init(viewModel : TermsAndConditionsVM){
        self.viewModel = viewModel
        super.init(nibName: "TermsAndConditionsVC", bundle: nil)
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
        self.title = "terms_and_conditions".localized
        bindViewModel()
        viewModel.termsAndConditionsRequest()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$termsAndConditions
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                let text = result?.data?.content ?? ""
                let convertedString = text.htmlToAttributedString
                staticPagesView.textView.attributedText = convertedString
            }
            .store(in: &cancellables)
        error(viewModel.$error)
    }
}
