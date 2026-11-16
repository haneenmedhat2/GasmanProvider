//
//  SelectLocationVM.swift
//  Profix
//
//  Created by Haneen on 12/01/2026.
//

import Foundation
import Combine

protocol SelectLocationVMProtocol {

    var onLocationSelected: ((AddressModel) -> Void)? { get set}
    var selectedAddress: AddressModel? { get set }
    var initialLocation: AddressModel? { get set }
}

final class SelectLocationVM : BaseViewModel , SelectLocationVMProtocol {

    var onLocationSelected: ((AddressModel) -> Void)?
    var selectedAddress: AddressModel?
    var initialLocation: AddressModel?
}
