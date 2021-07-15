//
//  AppCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        routeToMainVC()
    }
    
    private func routeToMainVC() {
        let coordinator = MainCoordinator(navigationController: self.navigationController)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
