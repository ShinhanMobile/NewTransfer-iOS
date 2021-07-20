//
//  TransferCheckCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import Foundation

class TransferCheckCoordinator: Coordinator {
    
    public var builder: TransferBuilder
    var children: [Coordinator] = []
    var router: Router
    
    public init(router: Router, builder: TransferBuilder) {
        self.router = router
        self.builder = builder
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        
        let viewModel = TransferCheckViewModel(transferBuilder: builder)
//        viewModel.coordinateDelegate = self
        let viewController = TransferCheckViewController(viewModel: viewModel)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    
    
}
