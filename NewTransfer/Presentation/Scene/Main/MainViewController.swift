//
//  ViewController.swift
//  NewTransfer
//
//  Created by Jongho Lee on 2021/07/07.
//

import UIKit

class MainViewController: UIViewController {
    
    var delegate: MainSubCoordiDelegate?
    
    @IBAction func transferButtonClicked(_ sender: Any) {
        self.delegate?.routeToTransfer()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
		mockNetworkSample()
//		devNetworkSample()
	}
    
}

