//
//  ViewController.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/07.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBAction func transferButtonClicked(_ sender: Any) {
        
        let transferRecipientVC = TransferRecipientViewController(
            viewModel: TransferRecipientViewModel(
                transferInfoManager: TransferInfoManager()
            )
        )
        
        self.navigationController?.pushViewController(transferRecipientVC, animated: true)
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		mockNetworkSample()
//		devNetworkSample()
	}
    
}

