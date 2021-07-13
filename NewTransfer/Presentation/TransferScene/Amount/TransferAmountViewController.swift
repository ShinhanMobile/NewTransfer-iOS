//
//  TransferAmountViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import UIKit

class TransferAmountViewController: UIViewController {

    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    private var transferInfoManager: TransferInfoManager
    
    init(transferInfoManager: TransferInfoManager){
        self.transferInfoManager = transferInfoManager
        super.init(nibName: "TransferAmountViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        
        // 받는 분
        self.recipientLabel.text = transferInfoManager.printRecipient()
        
        // 보낼 금액
        self.amountTextField.keyboardType = UIKeyboardType.numberPad
        
        // 확인 버튼
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let confirmButton = UIButton.init(type: .custom)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = .blue
        confirmButton.addTarget(self, action: #selector(confirmButtonClicked), for: .touchUpInside)
        
        let confirmBarButton = UIBarButtonItem.init(customView: confirmButton)
        
        toolbar.items = [confirmBarButton]
        
        amountTextField.inputAccessoryView = toolbar
    }

    @objc func confirmButtonClicked() {
        if let amount = self.amountTextField.text {
            transferInfoManager.amount = amount
            
            let transferCompleteVC = TransferCompleteViewController(transferInfoManager: transferInfoManager)
            transferCompleteVC.modalPresentationStyle = .fullScreen
            present(transferCompleteVC, animated: false, completion: nil)
            
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
}
