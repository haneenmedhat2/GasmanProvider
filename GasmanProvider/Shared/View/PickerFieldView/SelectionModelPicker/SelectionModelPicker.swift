//
//  SelectionModel.swift
//  Cleaf
//
//  Created by Haneen on 22/06/2025.
//

import Foundation

protocol SelectionModelPicker {
    var pickerId: Int { get }
    var pickerName: String { get }
}

protocol SelectionPopUpDelegate: AnyObject {
    func onsSelectedItem(items: SelectionModelPicker)
}
