//
//  TransferCoordinator.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/14.
//

import Foundation
import UIKit

class TransferCoordinator: Coordinator, TransferRecipientVMCoordinatorDelegate, TransferAmountVMCoordinatorDelegate, TransferInquiryVMCoordinatorDelegate, TransferCompleteVMCoordinatorDelegate {
    
    public var children: [Coordinator] = []
    public let router: Router
    
    public var builder: TransferBuilder
    public var bottomSheet: BottomSheet?
    
    
    public init(router: Router) {
        self.router = router
        builder = TransferBuilder()
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        
        let viewModel = TransferRecipientViewModel(transferBuilder: builder)
        viewModel.coordinatorDelegate = self
        let viewController = TransferRecipientViewController(viewModel: viewModel)
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
    
    // MARK: - TransferRecipientVMCoordinatorDelegate
    func routeToAmount(transferBuilder: TransferBuilder) {
        builder = transferBuilder
        
        presentAmountViewController()
    }
    
    
    // MARK: - TransferAmountVMCoordinatorDelegate
    func routeToInquiry(transferBuilder: TransferBuilder, parentViewController: UIViewController) {
        builder = transferBuilder
        
        presentInquiryBottomSheet(parentViewController: parentViewController)
    }
    
    // MARK: - TransferInquiryVMCoordinatorDelegate
    func cancel() {
        bottomSheet?.dismissSheet()
    }
    
    func transferComplete() {
        bottomSheet?.dismissSheet()
        
        // TODO: 이체하기를 누르면 비밀번호 떠야 함.
    }
    

    // MARK: - TransferCompleteVMCoordinatorDelegate
    func dismissTransfer() {
        router.dismiss(animated: true)
    }
    
    
    
    // MARK: - Present ViewController
    private func presentAmountViewController() {
        
        // TODO: Provider 사용
        let viewModel = TransferAmountViewModel(transferBuilder: builder)
        viewModel.coordinateDelegate = self
        let viewController = TransferAmountViewController(viewModel: viewModel)
        router.present(viewController, animated: true)
    }
    
    private func presentInquiryBottomSheet(parentViewController: UIViewController) {
        
        let viewModel = TransferInquiryViewModel(transferBuilder: builder)
        viewModel.coordinateDelegate = self
        let viewController = TransferInquiryViewController(viewModel: viewModel)
        // 바텀 시트는 그 안에서 또 화면을 띄우지 않고 한번밖에 못띄우기 때문에 router로 만들지 않아도 될 듯
        // router로 만들면 router 안에 init을 여러개 만들어야 함
        bottomSheet = BottomSheet(childViewController: viewController)
        bottomSheet?.show(presentView: parentViewController)
    }
    
    private func presentCompleteViewController() {
        
        // TODO: Provider 사용
        let viewModel = TransferCompleteViewModel(transferBuilder: builder)
        viewModel.coordinatorDelegate = self
        let viewController = TransferCompleteViewController(viewModel: viewModel)
        router.present(viewController, animated: true)
    }
}
