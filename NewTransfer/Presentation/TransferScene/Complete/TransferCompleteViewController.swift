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
    
    private var viewModel: TransferCompleteViewModel
    
    init(viewModel: TransferCompleteViewModel){
        self.viewModel = viewModel
        super.init(nibName: "TransferCompleteViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    private func bind() {
        let output = viewModel.transform(input: TransferCompleteViewModel.Input())
        
        recipientLabel.text = output.recipient
        amountLabel.text = output.amount
    }
}
