//
//  TransferAmountViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import UIKit
import RxSwift
import RxCocoa

class TransferAmountViewController: UIViewController {

    @IBOutlet weak var recipientLabel: UILabel!
    @IBOutlet weak var amountTextField: UITextField!
    
    private var viewModel: TransferAmountViewModel
    
    init(viewModel: TransferAmountViewModel){
        self.viewModel = viewModel
        super.init(nibName: "TransferAmountViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
    }
    
    private func configureUI() {
        
        // 보낼 금액 키패드
        self.amountTextField.keyboardType = UIKeyboardType.numberPad
        self.amountTextField.becomeFirstResponder()
        
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
    
    private func bind() {
        
        // viewModel bind
        let output = viewModel.transform(
            input: TransferAmountViewModel.Input(
                amount: amountTextField.rx.text.asObservable()
            )
        )
        
        self.recipientLabel.text = output.recipient
    }

    @objc func confirmButtonClicked() {
        amountTextField.resignFirstResponder()
        viewModel.routeToInquiry(parentViewController: self)
    }
}
