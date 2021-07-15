//
//  TransferAmountViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

protocol TransferAmountVMCoordiDelegate {
    func routeToCompleteVC()
}

class TransferAmountViewModel: TransferViewModel {
    
    struct Input {
        var amount: Observable<String?>
    }
    
    struct Output {
        var recipient: String
    }
    
    private let disposeBag = DisposeBag()
    internal var transferInfoManager: TransferInfoManager
    var coordinateDelegate: TransferAmountVMCoordiDelegate?
    
    init(transferInfoManager: TransferInfoManager) {
        self.transferInfoManager = transferInfoManager
    }
    
    func transform(input: Input) -> Output {
        
        input.amount
            .subscribe(onNext: { [weak self] amount in
                guard let self = self else { return }
                self.transferInfoManager.amount = amount
            })
            .disposed(by: disposeBag)
        
        return Output(recipient: transferInfoManager.printRecipient())
    }
    
    func routeToCompleteVC() {
        self.coordinateDelegate?.routeToCompleteVC()
    }
    
}
