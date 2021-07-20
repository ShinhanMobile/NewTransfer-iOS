//
//  TransferRepository.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

class TransferRepository: TransferRepositoryProtocol {
    
    func fetchTransferBasicInfo(request: FetchTransferBasicInfoUseCaseModels.Request) -> Observable<FetchTransferBasicInfoUseCaseModels.Response> {
        
        // 테스트용 하드코딩
        return Observable.just(FetchTransferBasicInfoUseCaseModels.Response(bankList: [
            Bank(name: "신한", code: "088"),
            Bank(name: "국민", code: "004"),
            Bank(name: "기업", code: "003"),
            Bank(name: "산업", code: "002"),
            Bank(name: "우리", code: "020"),
            Bank(name: "하나", code: "081")
        ]))
    }
    
    func inquiryRecipient(request: InquiryRecipientUseCaseModels.Request) -> Observable<InquiryRecipientUseCaseModels.Response> {
        
        // 테스트용 하드코딩
        if request.bank.name == "신한" && request.accountNumber == "11" {
            return Observable.just(InquiryRecipientUseCaseModels.Response(recipientName: "양시연"))
        } else if request.bank.name == "국민" && request.accountNumber == "22" {
            return Observable.just(InquiryRecipientUseCaseModels.Response(recipientName: "이종호"))
        } else {
            return Observable.just(InquiryRecipientUseCaseModels.Response(recipientName: "김은영"))
        }
    }
}
