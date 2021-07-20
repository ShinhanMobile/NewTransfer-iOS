//
//  FetchBankList.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

protocol FetchTransferBasicInfoUseCaseProtocol {
    func execute(request: FetchTransferBasicInfoUseCaseModels.Request) -> Observable<FetchTransferBasicInfoUseCaseModels.Response>
}

enum FetchTransferBasicInfoUseCaseModels {
    struct Request {
        
    }
    
    struct Response {
        var bankList: [Bank]
    }
}

class FetchTransferBasicInfoUseCase: FetchTransferBasicInfoUseCaseProtocol {
    
    var transferRepository: TransferRepositoryProtocol
    
    init(transferRepository: TransferRepositoryProtocol) {
        self.transferRepository = transferRepository
    }
    
    func execute(request: FetchTransferBasicInfoUseCaseModels.Request) -> Observable<FetchTransferBasicInfoUseCaseModels.Response> {
        return transferRepository.fetchTransferBasicInfo(request: request)
    }
    
}
