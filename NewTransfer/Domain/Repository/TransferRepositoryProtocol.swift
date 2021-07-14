//
//  TransferRepository.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

protocol TransferRepositoryProtocol {
    func fetchTransferBasicInfo(request: FetchTransferBasicInfoUseCaseModels.Request) -> Observable<FetchTransferBasicInfoUseCaseModels.Response>
}
