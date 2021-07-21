//
//  MainCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import UIKit

class MainCoordinator: Coordinator, MainVCCoordinatorDelegate {
    
    public var children: [Coordinator] = []
    public let router: Router
    
    public init(router: Router) {
        self.router = router
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = MainViewController()
        viewController.coordinatorDelegate = self
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    
    // MARK: - MainVCCoordinatorDelegate
    func mainVCDidClickTransfer(_ viewController: MainViewController) {
        let router = ModalNavigationRouter(parentViewController: viewController)
        let coordinator = TransferCoordinator(router: router)
        presentChild(coordinator, animated: true)
    }
}
