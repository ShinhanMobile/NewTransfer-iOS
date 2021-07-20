//
//  TransferCompleteViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

protocol TransferCompleteVMCoordinatorDelegate: class {
    func dismissTransfer()
}

class TransferCompleteViewModel: TransferViewModel {

    struct Input {
        
    }
    
    struct Output {
        var recipient: String
        var amount: String
    }
    
    private let disposeBag = DisposeBag()
    internal var transferBuilder: TransferBuilder
    weak var coordinatorDelegate: TransferCoordinator?
    
    init(transferBuilder: TransferBuilder) {
        self.transferBuilder = transferBuilder
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            recipient: transferBuilder.printRecipient(),
            amount: transferBuilder.printAmount()
        )
    }
    
    func dismiss() {
        self.coordinatorDelegate?.dismissTransfer()
    }
}
