//
//  TransferRecipientViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/13.
//

import UIKit
import RxSwift

class TransferRecipientViewController: UIViewController {

    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    
    lazy var bankPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 220)
        
        pickerView.backgroundColor = .white
        
        return pickerView
    }()
    
    var viewModel: TransferRecipientViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: TransferRecipientViewModel){
        self.viewModel = viewModel
        super.init(nibName: "TransferRecipientViewController", bundle: nil)
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
    
    private func bind() {
        
        let observableBank = PublishSubject<Bank>()
        
        bankPickerView.rx.modelSelected(Bank.self)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                
                if let selectedBank = item.first {
                    observableBank.onNext(selectedBank)
                    self.bankNameTextField.text = selectedBank.name
                    self.bankNameTextField.endEditing(true)
                }
                
            })
            .disposed(by: disposeBag)
        
        // viewModel bind
        let output = viewModel.transform(
            input: TransferRecipientViewModel.Input(
                selectedBank: observableBank,
                accountNumber: accountTextField.rx.text.asObservable()
            )
        )
        
        output.bankList
            .bind(to: bankPickerView.rx.itemTitles) { _, item in
                return item.name
            }
            .disposed(by: disposeBag)
        
    }
    
    @objc func confirmButtonClicked() {
        routeToTransferAmount()
    }
    
    private func routeToTransferAmount() {
        let transferInfoManager = viewModel.transferInfoManager
        let transferAmountVC = TransferAmountViewController(
            viewModel: TransferAmountViewModel(transferInfoManager: transferInfoManager)
        )
        
        self.navigationController?.pushViewController(transferAmountVC, animated: true)
    }
}

