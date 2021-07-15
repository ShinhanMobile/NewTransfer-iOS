//
//  TransferViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import Foundation
import RxSwift
import RxCocoa

protocol TransferRecipientVMCoordiDelegate {
    func routeToAmountVC(transferInfoManager: TransferInfoManager)
}

class TransferRecipientViewModel: TransferViewModel {
    
    struct Input {
        var selectedBank: Observable<Bank>
        var accountNumber: Observable<String?>
    }
    
    struct Output {
        var bankList: Observable<[Bank]>
    }
   
    private let fetchTransferBasicInfoUseCase = FetchTransferBasicInfoUseCase(transferRepository: TransferRepository())
    
    private let disposeBag = DisposeBag()
    internal var transferInfoManager: TransferInfoManager
    var coordinatorDelegate: TransferRecipientVMCoordiDelegate?
    
    init(
        transferInfoManager: TransferInfoManager
    ) {
        self.transferInfoManager = transferInfoManager
    }
    
    func transform(input: Input) -> Output {
        
        let recipient = Observable.combineLatest(input.selectedBank, input.accountNumber, resultSelector: { bank, accountNumber in
            Recipient(bank: bank, accountNumber: accountNumber ?? "")
        })
        
        recipient.subscribe(onNext: { [weak self] recipient in
            guard let self = self else { return }
            self.transferInfoManager.recipient = recipient
        })
        .disposed(by: disposeBag)
        
        let bankList = fetchTransferBasicInfoUseCase.execute(
            request: FetchTransferBasicInfoUseCaseModels.Request()
        )
        .map { response in
            response.bankList
        }
        
        return Output(bankList: bankList)
    }

    func routeToAmountVC() {
        self.coordinatorDelegate?.routeToAmountVC(transferInfoManager: self.transferInfoManager)
    }
    
}
