//
//  ChangePhoneMode.swift
//  GasMan
//
//  Created by Haneen on 16/02/2026.
//

import Foundation

enum ChangePhoneMode {
    case oldPhone
    case newPhone
    
    var typeNum : Int {
        switch self {
        case .oldPhone:
            return 1
        case .newPhone:
            return 2
        }
    }
}
