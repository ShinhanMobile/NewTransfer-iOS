//
//  TransferAmountViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift

protocol TransferAmountVMCoordinatorDelegate: class {
    func routeToInquiry(transferBuilder: TransferBuilder, parentViewController: UIViewController)
}

class TransferAmountViewModel: TransferViewModel {
    
    struct Input {
        var amount: Observable<String?>
    }
    
    struct Output {
        var recipient: String
    }
    
    private let disposeBag = DisposeBag()
    internal var transferBuilder: TransferBuilder
    weak var coordinateDelegate: TransferAmountVMCoordinatorDelegate?
    
    init(transferBuilder: TransferBuilder) {
        self.transferBuilder = transferBuilder
    }
    
    func transform(input: Input) -> Output {
        
        input.amount
            .subscribe(onNext: { [weak self] amount in
                guard let self = self else { return }
                self.transferBuilder.amount = amount
            })
            .disposed(by: disposeBag)
        
        return Output(recipient: transferBuilder.printRecipient())
    }
    
    func routeToInquiry(parentViewController: UIViewController) {
        self.coordinateDelegate?.routeToInquiry(
            transferBuilder: transferBuilder,
            parentViewController: parentViewController
        )
    }
    
}
