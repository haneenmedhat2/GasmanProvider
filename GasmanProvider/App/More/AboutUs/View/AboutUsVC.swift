//
//  AboutUsVC.swift
//  Esterad
//
//  Created by Haneen on 11/11/2025.
//

import UIKit
import Combine

class AboutUsVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var staticPagesView: StaticPagesView!
    
    //MARK: - Properties -
    
    var viewModel : AboutUsVM
    
    //MARK: - Initializer -
    
    init(viewModel : AboutUsVM){
        self.viewModel = viewModel
        super.init(nibName: "AboutUsVC", bundle: nil)
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
        self.title = "about_app".localized
        bindViewModel()
        viewModel.aboutUsRequest()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)

        viewModel.$aboutUs
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
