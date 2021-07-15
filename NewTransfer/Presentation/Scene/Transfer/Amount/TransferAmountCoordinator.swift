//
//  TransferAmountCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

class TransferAmountCoordinator: Coordinator, TransferAmountVMCoordiDelegate {
    
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
        let viewModel = TransferAmountViewModel(transferInfoManager: transferInfoManager)
        viewModel.coordinateDelegate = self
        let vc = TransferAmountViewController(viewModel: viewModel)
                                              
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func routeToCompleteVC() {
        self.delegate?.routeToCompleteVC(self, transferInfoManager: self.transferInfoManager)
    }
}
