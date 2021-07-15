//
//  TransferCompleteCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

class TransferCompleteCoordinator: Coordinator, TransferCompleteVMCoordiDelegate {
    
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
        let viewModel = TransferCompleteViewModel(transferInfoManager: transferInfoManager)
        viewModel.coordinatorDelegate = self
        let vc = TransferCompleteViewController(viewModel: viewModel)
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController.present(vc, animated: true, completion: nil)
    }
    
    func dismissTransferVC() {
        self.navigationController.dismiss(animated: false)
        self.delegate?.dismissTransferVC(self)
        
    }
    
}
