//
//  Recipient.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation

struct Recipient {
    let bankName: String
    let accountNumber: String
    
    let name: String?
    
    init(bankName: String, accountNumber: String) {
        self.bankName = bankName
        self.accountNumber = accountNumber
        
        self.name = nil
    }
}
