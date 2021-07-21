//
//  TransferInquiryViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import Foundation
import RxSwift

protocol TransferInquiryVMCoordinatorDelegate: class {
    func cancel()
    func transferComplete()
}

class TransferInquiryViewModel: TransferViewModel {

    struct Input {
        // 버튼 누르는 것을 input으로 두어야 할까?
        // TODO: 얘기해보기
    }
    
    struct Output {
        var recipientName: Observable<String>
        var amount: String
        var recipientAccount: String
    }
    
    private let inquiryRecipientUseCase = InquiryRecipientUseCase(transferRepository: TransferRepository())
    
    private let disposeBag = DisposeBag()
    internal var transferBuilder: TransferBuilder
    weak var coordinateDelegate: TransferInquiryVMCoordinatorDelegate?
    
    init(transferBuilder: TransferBuilder) {
        self.transferBuilder = transferBuilder
    }
    
    func transform(input: Input) -> Output {
        
        guard let recipient = transferBuilder.recipient else {
            return Output(recipientName: Observable.just("없음"), amount: transferBuilder.printAmount(), recipientAccount: "계좌 없음")
        }
        
        let recipientName = inquiryRecipientUseCase.execute(
            request: InquiryRecipientUseCaseModels.Request(
                bank: recipient.bank,
                accountNumber: recipient.accountNumber
            )
        )
        .map { response in
            return response.recipientName
        }
        
        return Output(recipientName: recipientName, amount: transferBuilder.printAmount(), recipientAccount: recipient.print())
    }
    
    func dismiss() {
        coordinateDelegate?.cancel()
    }
    
    func transferButtonClicked() {
        // 이체 실행: transferUsecase.excute
        coordinateDelegate?.transferComplete()
    }
}
