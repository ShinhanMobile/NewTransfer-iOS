//
//  TransferBuilder.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import Foundation

public class TransferBuilder {
    var trxKey: String?             // 거래 일련번호
    var recipient: Recipient?       // 수취인
    var amount: String?             // 이체 금액
    
    // 이거를 여기서 처리하는게 맞나?
    func printRecipient() -> String {
        guard let recipient = self.recipient else {
            return "수취인 조회 실패"
        }
        
        return recipient.bank.name + " " + recipient.accountNumber
    }
    
    func printAmount() -> String {
        guard let amount = self.amount else {
            return "이체 금액 없음"
        }
        
        return amount + "원"
    }
}
