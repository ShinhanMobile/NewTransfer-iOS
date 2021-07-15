//
//  MainCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

protocol MainCoordiDelegate {
    func popToMainVC(_ coordinator: Coordinator)
}

protocol MainSubCoordiDelegate {
    func routeToTransfer()
}

class MainCoordinator: Coordinator, MainSubCoordiDelegate, MainCoordiDelegate {
    
    var childCoordinators: [Coordinator] = []
    
    private var mainViewController: MainViewController
    private var navigationController: UINavigationController
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.mainViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    }
    
    func start() {
        mainViewController.delegate = self
        self.navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func popToMainVC(_ coordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.navigationController.popToViewController(mainViewController, animated: false)
    }
    
    func routeToTransfer() {
        let coordinator = TransferCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
    
    
}
