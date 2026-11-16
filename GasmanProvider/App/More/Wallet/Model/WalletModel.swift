//
//  WalletModel.swift
//  Esterad
//
//  Created by Haneen on 05/11/2025.
//

import Foundation

struct WalletResponse : Codable {
    let balance : String
    let availableBalance : String
    let pendingBalance : String
    
    enum CodingKeys: String, CodingKey {
        case balance
        case availableBalance = "available_balance"
        case pendingBalance = "pending_balance"
    }
}


struct WithdrawMoney : Codable {
    let amount : String?
    let bankName : String?
    let bankAccountNumber : String?
    let iban : String?
    let type : Int  // 0 = wallet, 1 = insurance
}
