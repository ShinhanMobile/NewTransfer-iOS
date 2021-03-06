//
//  Router.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import UIKit

public protocol Router: class {
    func present(_ viewController: UIViewController, animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
}

extension Router {
    
    public func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, onDismissed: nil)
    }
}
