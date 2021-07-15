//
//  TransferCompleteViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

protocol TransferCompleteVMCoordiDelegate {
    func dismissTransferVC()
}

class TransferCompleteViewModel: TransferViewModel {

    struct Input {
        
    }
    
    struct Output {
        var recipient: String
        var amount: String
    }
    
    private let disposeBag = DisposeBag()
    internal var transferInfoManager: TransferInfoManager
    
    var coordinatorDelegate: TransferCompleteVMCoordiDelegate?
    
    init(transferInfoManager: TransferInfoManager) {
        self.transferInfoManager = transferInfoManager
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            recipient: transferInfoManager.printRecipient(),
            amount: transferInfoManager.printAmount()
        )
    }
    
    func dismiss() {
        self.coordinatorDelegate?.dismissTransferVC()
    }
}
