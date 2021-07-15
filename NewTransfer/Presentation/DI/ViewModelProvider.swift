//
//  DI+ViewModel.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation

class ViewModelProvider: ViewModelFactory {
    
    let transferInfoManager: TransferInfoManager
    
    init(transferInfoManager: TransferInfoManager) {
        self.transferInfoManager = transferInfoManager
    }
    
    var transferRecipientViewModel: TransferRecipientViewModel {
        return TransferRecipientViewModel(transferInfoManager: transferInfoManager)
    }
    
    var transferAmountViewModel: TransferAmountViewModel {
        return TransferAmountViewModel(transferInfoManager: transferInfoManager)
    }
    
    var transferCompleteViewModel: TransferCompleteViewModel {
        return TransferCompleteViewModel(transferInfoManager: transferInfoManager)
    }
    
}
