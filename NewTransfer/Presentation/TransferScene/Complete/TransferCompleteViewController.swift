//
//  TransferCompleteViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import UIKit

class TransferCompleteViewController: UIViewController {
    
    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBAction func confirmButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private var transferInfoManager: TransferInfoManager
    
    init(transferInfoManager: TransferInfoManager){
        self.transferInfoManager = transferInfoManager
        super.init(nibName: "TransferCompleteViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    
    }
    
    private func configureUI() {
        recipientLabel.text = transferInfoManager.printRecipient()
        amountLabel.text = transferInfoManager.amount
    }

}
