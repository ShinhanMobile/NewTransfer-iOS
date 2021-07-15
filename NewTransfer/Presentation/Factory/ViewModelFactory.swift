//
//  ViewModelFactory.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation

protocol ViewModelFactory {
    
    // transfer
    var transferRecipientViewModel: TransferRecipientViewModel { get }
    var transferAmountViewModel: TransferAmountViewModel { get }
    var transferCompleteViewModel: TransferCompleteViewModel { get }
}
