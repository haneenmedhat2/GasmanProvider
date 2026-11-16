//
//  MyRatingsVC.swift
//  GasMan
//
//  Created by Haneen on 18/02/2026.
//

import UIKit
import Combine

class MyRatingsVC: BaseViewController {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properties -
    
    var viewModel : MyRatingsVM
    
    //MARK: - Initializer -
    
    init(viewModel : MyRatingsVM){
        self.viewModel = viewModel
        super.init(nibName: "MyRatingsVC", bundle: nil)
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
        self.title = "my_ratings".localized
        view.isHidden = true
        bindToViewModel()
        configureTableView()
        viewModel.getReviews()
    }
    
    //MARK: - ViewModel Binding -

    func bindToViewModel(){
        loading(viewModel.$isLoading)
        
        viewModel.$reviews
            .sinkOnMain{ [weak self] _ in
                guard let self = self else { return }
                view.isHidden = false
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        error(viewModel.$error)
    }
}

//MARK: - TableView Configurations -

extension MyRatingsVC : UITableViewDataSource, UITableViewDelegate {
    
    func configureTableView(){
        tableView.register(cellType: MyRatingsCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.setPlaceholder(isEmpty: viewModel.reviews.isEmpty , separator: .none, style: .emptyRatings)
        return viewModel.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MyRatingsCell.self, for: indexPath)
        let item = viewModel.reviews[indexPath.row]
        cell.setupCell(model: item)
        return cell
    }
    
}

