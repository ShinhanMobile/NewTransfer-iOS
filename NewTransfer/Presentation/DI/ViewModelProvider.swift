//
//  DI+ViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation

class ViewModelProvider: ViewModelFactory {
    
    let transferBuilder: TransferBuilder
    
    init(transferBuilder: TransferBuilder) {
        self.transferBuilder = transferBuilder
    }
    
    var transferRecipientViewModel: TransferRecipientViewModel {
        return TransferRecipientViewModel(transferBuilder: transferBuilder)
    }
    
    var transferAmountViewModel: TransferAmountViewModel {
        return TransferAmountViewModel(transferBuilder: transferBuilder)
    }
    
    var transferCompleteViewModel: TransferCompleteViewModel {
        return TransferCompleteViewModel(transferBuilder: transferBuilder)
    }
    
}
