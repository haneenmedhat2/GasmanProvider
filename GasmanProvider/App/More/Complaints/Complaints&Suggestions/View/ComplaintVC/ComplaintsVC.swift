//
//  ComplaintsVC.swift
//  Esterad
//
//  Created by Haneen on 06/11/2025.
//

import UIKit
import Combine

class ComplaintsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var complaintTitleTextField: GeneralTextField!
    @IBOutlet weak var complaintContextTextField: GeneralTextField!
    @IBOutlet weak var complaintImagesView: ComplaintImagesView!
    
    //MARK: - Properties -
    
    var viewModel : ComplaintsVM
    
    //MARK: - Initializer -
    
    init(viewModel : ComplaintsVM){
        self.viewModel = viewModel
        super.init(nibName: "ComplaintsVC", bundle: nil)
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
        self.title = "complaints_suggestions".localized
        complaintImagesView.isHidden = Session.userType == .serviceProvider
        bindViewModel()
        configureCollectionView()
    }
    
    //MARK: - ViewModel Binding -

    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$complaint
            .compactMap{ $0 }
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.showPopup(title : result.message)
            }
            .store(in: &cancellables)
        
        viewModel.$validationError
            .compactMap{ $0 }
            .sinkOnMain { [weak self] error in
                guard let self = self else { return }
                show(errorMessage: error.localizedDescription)
            }
            .store(in: &cancellables)

        error(viewModel.$error)
    }
    
    //MARK: - Actions -

    @IBAction func didTapSend(_ sender: UIButton) {
        let model = ComplaintsModel(
            subject: complaintTitleTextField.txtField.text,
            complaint: complaintContextTextField.txtField.text,
            type: viewModel.complaintsList[viewModel.indexPath.row].apiValue,
            images: complaintImagesView.imagesList.map{ $0.data }
        )
        
        viewModel.validateInputs(model: model)
    }
}

//MARK: - CollectionView configuration -

extension ComplaintsVC : UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    
    func configureCollectionView(){
        collectionView.register(cellType: SelectableOptionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.complaintsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SelectableOptionCell.self , for: indexPath )
        let item = viewModel.complaintsList[indexPath.row]
        cell.setupCell(model: item, isSelected: viewModel.indexPath == indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath != viewModel.indexPath {
            viewModel.indexPath = indexPath
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.width - 12) / 2, height: 40)
    }
}

//MARK: - Routes -

extension ComplaintsVC {

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
