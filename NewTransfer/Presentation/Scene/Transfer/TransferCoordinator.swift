//
//  TransferCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

class TransferCoordinator: Coordinator, TransferRecipientVMCoordinatorDelegate, TransferAmountVMCoordinatorDelegate, TransferCheckVMCoordinatorDelegate,  TransferCompleteVMCoordinatorDelegate {
    
    public var builder: TransferBuilder
    public var children: [Coordinator] = []
    public let router: Router
    
    public init(router: Router) {
        self.router = router
        builder = TransferBuilder()
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        
        let viewModel = TransferRecipientViewModel(transferBuilder: builder)
        viewModel.coordinatorDelegate = self
        let viewController = TransferRecipientViewController(viewModel: viewModel)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    // MARK: TransferRecipientVMCoordinatorDelegate
    func routeToAmount(transferBuilder: TransferBuilder) {
        builder = transferBuilder
        
        presentAmountViewController()
    }
    
    
    // MARK: TransferAmountVMCoordinatorDelegate
    func routeToCheck(transferBuilder: TransferBuilder, parentViewController: UIViewController) {
        builder = transferBuilder
        
        presentCheckBottonSheet(parentViewController: parentViewController)
    }
    
    
    // MARK: TransferCheckVMCoordinatorDelegate
    func dismissTransferCheck() {
        
    }
    
    func routeToComplete() {
        
    }
    
    
    // MARK: TransferCompleteVMCoordinatorDelegate
    func dismissTransfer() {
        router.dismiss(animated: true)
    }
    
    
    
    // MARK: - Present ViewController
    private func presentAmountViewController() {
        
        // TODO: Provider 사용
        let viewModel = TransferAmountViewModel(transferBuilder: builder)
        viewModel.coordinateDelegate = self
        let viewController = TransferAmountViewController(viewModel: viewModel)
        router.present(viewController, animated: true)
    }
    
    private func presentCheckBottonSheet(parentViewController: UIViewController) {
        
        let viewModel = TransferCheckViewModel(transferBuilder: builder)
        viewModel.coordinateDelegate = self
        let viewController = TransferCheckViewController(viewModel: viewModel)
        
        let bottomSheet = BottomSheet(childViewController: viewController, isTapDismiss: false, availablePanning: false)
        bottomSheet.show(presentView: parentViewController)
    }
    
    private func presentCompleteViewController() {
        
        // TODO: Provider 사용
        let viewModel = TransferCompleteViewModel(transferBuilder: builder)
        viewModel.coordinatorDelegate = self
        let viewController = TransferCompleteViewController(viewModel: viewModel)
        router.present(viewController, animated: true)
    }
}
