//
//  MainViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/16.
//

import UIKit

protocol MainVCCoordinatorDelegate {
    func mainVCDidClickTransfer(_ viewController: MainViewController)
}

class MainViewController: UIViewController {
    
    weak var coordinatorDelegate: MainCoordinator?
    
    @IBAction func transferButtonClicked(_ sender: Any) {
        self.coordinatorDelegate?.mainVCDidClickTransfer(self)
    }
    
    init(delegate: MainCoordinator) {
        self.coordinatorDelegate = delegate
        
        super.init(nibName: "MainViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mockNetworkSample()
//        devNetworkSample()
    }
}
