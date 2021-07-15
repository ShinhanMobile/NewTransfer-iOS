//
//  TransferRecipientCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

class TransferRecipientCoordinator: Coordinator, TransferRecipientVMCoordiDelegate {
   
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController
    private var transferInfoManager: TransferInfoManager
    
    var delegate: TransferSubCoordiDelegate?
    
    init(
        navigationController: UINavigationController,
        transferInfoManager: TransferInfoManager
    ) {
        self.navigationController = navigationController
        self.transferInfoManager = transferInfoManager
    }
    
    func start() {
        let viewModel = TransferRecipientViewModel(transferInfoManager: transferInfoManager)
        viewModel.coordinatorDelegate = self
        let vc = TransferRecipientViewController(viewModel: viewModel)
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func routeToAmountVC(transferInfoManager: TransferInfoManager) {
        self.delegate?.routeToAmountVC(self, transferInfoManager: transferInfoManager)
    }
}

