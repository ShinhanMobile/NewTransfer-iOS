//
//  TransferCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

protocol TransferSubCoordiDelegate {
    func routeToRecipientVC()
    func routeToAmountVC(_ coordinator: Coordinator, transferInfoManager: TransferInfoManager)
    func routeToCompleteVC(_ coordinator: Coordinator, transferInfoManager: TransferInfoManager)
    func dismissTransferVC(_ coordinator: Coordinator)
}

class TransferCoordinator: Coordinator, TransferSubCoordiDelegate {
    
    var childCoordinators: [Coordinator] = []
    
    private var navigationController: UINavigationController
    private var transferInfoManager: TransferInfoManager
    
    var delegate: MainCoordiDelegate?
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        
        transferInfoManager = TransferInfoManager()
    }
    
    func start() {
        routeToRecipientVC()
    }
    
    func routeToRecipientVC() {
        let coordinator = TransferRecipientCoordinator(
            navigationController: self.navigationController,
            transferInfoManager: self.transferInfoManager
        )
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func routeToAmountVC(_ coordinator: Coordinator, transferInfoManager: TransferInfoManager) {
        configureBeforeTransferRoute(coordinator: coordinator, transferInfoManager: transferInfoManager)
        
        let coordinator = TransferAmountCoordinator(
            navigationController: self.navigationController,
            transferInfoManager: self.transferInfoManager
        )
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func routeToCompleteVC(_ coordinator: Coordinator, transferInfoManager: TransferInfoManager) {
        configureBeforeTransferRoute(coordinator: coordinator, transferInfoManager: transferInfoManager)
        
        let coordinator = TransferCompleteCoordinator(
            navigationController: self.navigationController,
            transferInfoManager: self.transferInfoManager
        )
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    func dismissTransferVC(_ coordinator: Coordinator) {
        delegate?.popToMainVC(self)
    }
    
    
    private func configureBeforeTransferRoute(coordinator: Coordinator, transferInfoManager: TransferInfoManager) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.transferInfoManager = transferInfoManager
    }
}
