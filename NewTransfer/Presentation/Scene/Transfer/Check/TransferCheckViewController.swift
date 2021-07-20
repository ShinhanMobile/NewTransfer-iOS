//
//  TransferCheckViewController.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import UIKit
import RxSwift
import RxCocoa

class TransferCheckViewController: UIViewController, FlexibleBottomSheetDelegate {
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recipientAccountLabel: UILabel!
    @IBOutlet weak var bottomSheetContentView: UIView!
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
    }
    
    @IBAction func transferButtonClicked(_ sender: Any) {
        
    }
    
    private var viewModel: TransferCheckViewModel
    
    let disposeBag = DisposeBag()
    
    init(viewModel: TransferCheckViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TransferCheckViewController", bundle: nil)
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
        self.view.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    private func bind() {
        let output = viewModel.transform(input: TransferCheckViewModel.Input())
        
        output.recipientName
            .bind(to: recipientNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.recipientAccountLabel.text = "받는계좌: " + output.recipientAccount
        self.amountLabel.text = output.amount
    }
}
