//
//  InquiryRecipientUseCase.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import Foundation
import RxSwift

protocol InquiryRecipientUseCaseProtocol {
    func execute(request: InquiryRecipientUseCaseModels.Request) -> Observable<InquiryRecipientUseCaseModels.Response>
}

enum InquiryRecipientUseCaseModels {
    struct Request {
        var bank: Bank
        var accountNumber: String
    }
    
    struct Response {
        var recipientName: String
    }
}

class InquiryRecipientUseCase: InquiryRecipientUseCaseProtocol {
    
    var transferRepository: TransferRepositoryProtocol
    
    init(transferRepository: TransferRepositoryProtocol) {
        self.transferRepository = transferRepository
    }
    
    func execute(request: InquiryRecipientUseCaseModels.Request) -> Observable<InquiryRecipientUseCaseModels.Response> {
        
        return transferRepository.inquiryRecipient(request: request)
    }
}
