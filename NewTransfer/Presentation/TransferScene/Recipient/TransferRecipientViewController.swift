//
//  TransferRecipientViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import UIKit

class TransferRecipientViewController: UIViewController {

    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    
    lazy var bankPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 220)
        
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        
        return pickerView
    }()
    
    var transferInfoManager: TransferInfoManager
    var bankList: [String] = [ "신한", "우리", "국민", "농협" ]
    
    init(transferInfoManager: TransferInfoManager){
        self.transferInfoManager = transferInfoManager
        super.init(nibName: "TransferRecipientViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.transferInfoManager = TransferInfoManager()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    private func configureUI() {
        
        // 은행 선택
        self.bankNameTextField.inputView = self.bankPickerView
        
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
        
        accountTextField.inputAccessoryView = toolbar
    }
    
    @objc func confirmButtonClicked() {
        if let bankName = self.bankNameTextField.text,
           let accountNumber = self.accountTextField.text {
            
            let recipient = Recipient(bankName: bankName, accountNumber: accountNumber)
            transferInfoManager.recipient = recipient
            
            let transferAmountVC = TransferAmountViewController(transferInfoManager: transferInfoManager)
            self.navigationController?.pushViewController(transferAmountVC, animated: true)
        }
    }
}



extension TransferRecipientViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bankList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bankList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        bankNameTextField.text = bankList[row]
        bankNameTextField.endEditing(true)
    }
}
