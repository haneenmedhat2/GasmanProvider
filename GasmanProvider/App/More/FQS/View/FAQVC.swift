//
//  FAQVC.swift
//  Esterad
//
//  Created by Haneen on 10/11/2025.
//

import UIKit
import Combine

class FAQVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties -
    
    var viewModel : FAQVM
    
    //MARK: - Initializer -
    
    init(viewModel : FAQVM){
        self.viewModel = viewModel
        super.init(nibName: "FAQVC", bundle: nil)
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
        self.title = "faq".localized
        bindViewModel()
        viewModel.faqRequest()
        configureTableView()
    }
    
    //MARK: - ViewModel Binding -
    
    private func bindViewModel() {
        loading(viewModel.$isLoading)
        
        viewModel.$faq
            .sinkOnMain { [weak self] result in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.store(in: &cancellables)
        
        error(viewModel.$error)
    }
}

extension FAQVC : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(FAQCell.self, forCellReuseIdentifier: FAQCell.identifier)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.faqList.count)
        return viewModel.faqList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FAQCell.identifier, for: indexPath) as! FAQCell
              let item = viewModel.faqList[indexPath.row]
              cell.configure(with: item)
              return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.faqList[indexPath.row].isExpanded.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

