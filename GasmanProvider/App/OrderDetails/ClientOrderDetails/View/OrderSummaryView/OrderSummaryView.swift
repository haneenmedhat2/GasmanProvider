//
//  OrderSummaryView.swift
//  Profix
//
//  Created by Haneen on 15/01/2026.
//

import UIKit

class OrderSummaryView: UIView {
    
    //MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: TableViewContentSized!
    
    //MARK: - Properites -
     
    var orderDataList : [KeyValueModel] = []
    var highlightLastRows: Bool = true
    
    //MARK: - Initializer -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewSetup()
    }
    
    //MARK: - Nib file configuration -
    
    func viewSetup(){
        let view = loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(view)
        configureTableView()
    }
        
    func loadViewFromNib()-> UIView {
        let nib = UINib(nibName: "OrderSummaryView", bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    

    func configure(dataSource: [KeyValueModel]) {
        self.orderDataList = dataSource
        tableView.reloadData()
    }
}

//MARK: - TableView Configuration -

extension OrderSummaryView : UITableViewDataSource, UITableViewDelegate {

    func configureTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(cellType: OrderSummaryCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: OrderSummaryCell.self, for: indexPath)
        let item = orderDataList[indexPath.row]
        cell.setupCell(model: item)
        let isLastTwo = highlightLastRows && indexPath.row >= orderDataList.count - 2
        cell.applyStyle(isHighlighted: isLastTwo)
        return cell
    }
}
