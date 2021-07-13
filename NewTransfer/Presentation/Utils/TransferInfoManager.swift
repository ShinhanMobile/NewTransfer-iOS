//
//  TransferInfoManager.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation

class TransferInfoManager {
    var trxKey: String?             // 거래 일련번호
    var recipient: Recipient?       // 수취인
    var amount: String?             // 이체 금액
    
    func printRecipient() -> String {
        guard let recipient = self.recipient else {
            return "수취인 조회 실패"
        }
        
        return recipient.bankName + " " + recipient.accountNumber
    }
}
