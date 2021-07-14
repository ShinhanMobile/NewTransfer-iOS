//
//  Recipient.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation

struct Recipient {
    let bank: Bank
    let accountNumber: String
    
    let name: String?
    
    init(bank: Bank, accountNumber: String) {
        self.bank = bank
        self.accountNumber = accountNumber
        
        self.name = nil
    }
    
    func print() -> String {
        return self.bank.name + " " + self.accountNumber
    }
}
