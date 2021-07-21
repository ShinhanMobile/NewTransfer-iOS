//
//  MainViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/16.
//

import UIKit

protocol MainVCCoordinatorDelegate: class {
    func mainVCDidClickTransfer(_ viewController: MainViewController)
}

class MainViewController: UIViewController {
    
    weak var coordinatorDelegate: MainVCCoordinatorDelegate?
    
    @IBAction func transferButtonClicked(_ sender: Any) {
        self.coordinatorDelegate?.mainVCDidClickTransfer(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockNetworkSample()
//        devNetworkSample()
    }
}
