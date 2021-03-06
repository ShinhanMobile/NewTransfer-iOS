//
//  BottomSheet.swift
//  NewTransfer
//
//  Created by  60117280 on 2021/07/20.
//

import UIKit

// MARK: - BottomSheet dismiss listener
@objc protocol BottomSheetDismissListenerDelegate: AnyObject {
    func completeDismissBottomSheet()
}

// MARK: - Flexible BottomSheet 채택 protocol
@objc protocol FlexibleBottomSheetDelegate: AnyObject {
    var bottomSheetContentView: UIView! { get set }
}

class BottomSheetTableView: UITableView {
    override func layoutSubviews() {
        if (self.window == nil) {
            return
        }
        super.layoutSubviews()
    }
}

class BottomSheetCollectionView: UICollectionView {
    override func layoutSubviews() {
        if (self.window == nil) {
            return
        }
        super.layoutSubviews()
    }
}

protocol ChangeableBottomSheetWithTableView: UIScrollViewDelegate {
    var tableView: BottomSheetTableView! { get set }
    var delegate: ChangeableScrollContentsDelegate? { get set }
}

protocol ChangeableBottomSheetWithCollectionView: UIScrollViewDelegate {
    var collectionView: BottomSheetCollectionView! { get set }
    var delegate: ChangeableScrollContentsDelegate? { get set }
}

protocol ChangeableScrollContentsDelegate: AnyObject {
    func contentsScrollViewDidScroll(_ scrollView: UIScrollView)
    func contentsScrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func contentsScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
}

class BottomSheet: UIViewController {
    // MARK: - Constant
    enum Constant {
        static let delay: Double = 0.3                      // 등장 delay
        static let maxDimAlpha: CGFloat = 0.5               // 최대 dim alpha
        static let flickingVelocity: CGFloat = 2000         // 반응 flicking 속도
    }
    // MARK: - Private variable
    private var childViewController: UIViewController!      // 바텀 시트에 들어갈 view들의 종류가 다양해서 나중에는 다양한 childViewController를 사용 할 것 같음
    private let containerView = UIView()                    // childViewController가 들어갈 컨테이너 뷰
    private let backgroundView = UIView()                   // 바텀시트 백그라운드 뷰
    private var dimColor: UIColor!                          // 백그라운드 dim color
    private var dim: Bool = true                            // 백그라운드 dim 여부
    private var noAddBottomSafeArea: Bool = false           // 바텀시트 높이 계산시, bottomSafeArea를 고려하지 않습니다.
    private var isTapDismiss: Bool = true                   // 백그라운드 뷰 터치시 dismiss 되는지 여부
    private var showCompletion: CommonFuncType?             // 바텀시트를 show 할때 수행 할 closure
    // MARK: - Public variable
    var sheetHeight: CGFloat = 0                            // 바텀시트 높이
    var initialHeight: CGFloat = 0                          // 확장 바텀시트의 최초 높이
    var isExpand: Bool = false                              // 바텀시트 확장 여부
    var topConstraint: NSLayoutConstraint = NSLayoutConstraint.init()            // 바텀시트의 컨테이너뷰 top constraint
    var heightConstraint: NSLayoutConstraint = NSLayoutConstraint.init()         // 바텀시트의 컨테이너뷰 height constraint
    var isKeyboardShow: Bool = false                        // 키보드가 등장한 상태인지 확인
    var modalType: ModalType = .fixed                       // 공통가이드의 Modal Type 구분
    var availablePanning: Bool = true                       // panning 가능 여부
    weak var dismissListener: BottomSheetDismissListenerDelegate?                // dismiss 되었을때 로직을 수행 할 listener

    typealias CommonFuncType =  ( () -> Void )              // callback 함수 typealias

    enum ModalType {
        case fixed         // Modal 높이 고정
        case flexible      // Modal 높이 유동적(bottomSheetContentView의 높이)
        case changeable    // Modal 높이 고정 + flicking으로 높이 변화 가능
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - bottom sheet initializer, child view controller를 container view로 사용한다.
    /// bottom sheet initializer(높이 고정)
    /// - Parameters:
    ///   - childViewController: bottom sheet의 container view에 들어갈 view controller
    ///   - height: bottom sheet 높이
    ///   - dim: background dim 처리 확인
    ///   - isTapDismiss: background가 tap으로 dismiss 되는지 확인
    ///   - availablePanning: bottom sheet의 panning을 허용하는지 확인
    ///   - dismissListener: bottom sheet가 dismiss 될때 수행되는 리스너, 해당 리스너는 dismissSheet의 completion handler 보다 우선순위가 낮음
    @objc init(childViewController: UIViewController, height: CGFloat, dim: Bool = true, isTapDismiss: Bool = true, availablePanning: Bool = true, dismissListener: BottomSheetDismissListenerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.childViewController = childViewController
        self.sheetHeight = height + getBottomSafeAreaInsets()
        self.dim = dim
        self.dimColor = (dim) ? UIColor(white: 0, alpha: Constant.maxDimAlpha) : UIColor.clear
        self.isTapDismiss = isTapDismiss
        self.availablePanning = availablePanning
        self.dismissListener = dismissListener
        self.modalPresentationStyle = .overFullScreen
        self.modalType = .fixed
    }

    /// bottom sheet initializer(높이 유동적)
    /// - Parameters:
    ///   - childViewController: bottom sheet의 container view에 들어갈 view controller(FlexibleBottomSheetDelegate를 상속)
    ///   - dim: background dim 처리 확인
    ///   - isTapDismiss: background가 tap으로 dismiss 되는지 확인
    ///   - availablePanning: bottom sheet의 panning을 허용하는지 확인
    ///   - dismissListener: bottom sheet가 dismiss 될때 수행되는 리스너, 해당 리스너는 dismissSheet의 completion handler 보다 우선순위가 낮음
    ///   - noAddBottomSafeArea: bottomSafeArea를 Height 계산시 고려하지 않습니다.
    @objc init(childViewController: UIViewController & FlexibleBottomSheetDelegate, dim: Bool = true, isTapDismiss: Bool = true, availablePanning: Bool = true, dismissListener: BottomSheetDismissListenerDelegate? = nil, noAddBottomSafeArea: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.childViewController = childViewController
        self.dim = dim
        self.dimColor = (dim) ? UIColor(white: 0, alpha: Constant.maxDimAlpha) : UIColor.clear
        self.isTapDismiss = isTapDismiss
        self.availablePanning = availablePanning
        self.dismissListener = dismissListener
        self.modalPresentationStyle = .overFullScreen
        self.modalType = .flexible
        self.noAddBottomSafeArea = noAddBottomSafeArea
    }

    /// bottom sheet initializer(높이 고정) + changeable(높이 변화 옵션)
    /// - Parameters:
    ///   - childViewController: bottom sheet의 container view에 들어갈 view controller
    ///   - initialHeight: bottom sheet 초기 높이
    ///   - maxHeight: bottom sheet 최대 높이
    ///   - dim: background dim 처리 확인
    ///   - isTapDismiss: background가 tap으로 dismiss 되는지 확인
    ///   - availablePanning: bottom sheet의 panning을 허용하는지 확인
    ///   - dismissListener: bottom sheet가 dismiss 될때 수행되는 리스너, 해당 리스너는 dismissSheet의 completion handler 보다 우선순위가 낮음
    @objc init(childViewController: UIViewController, initialHeight: CGFloat, maxHeight: CGFloat, dim: Bool = true, isTapDismiss: Bool = true, dismissListener: BottomSheetDismissListenerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.childViewController = childViewController
        let bottomSafeAreaInsets = getBottomSafeAreaInsets()
        self.sheetHeight = maxHeight + bottomSafeAreaInsets
        self.initialHeight = initialHeight + bottomSafeAreaInsets
        self.dim = dim
        self.dimColor = (dim) ? UIColor(white: 0, alpha: Constant.maxDimAlpha) : UIColor.clear
        self.isTapDismiss = isTapDismiss
        self.availablePanning = true
        self.dismissListener = dismissListener
        self.modalPresentationStyle = .overFullScreen
        self.modalType = .changeable
    }

    /// bottom sheet initializer(높이 고정) + changeable(높이 변화 옵션) + scroll view가 childViewController에 있는 경우
    /// - Parameters:
    ///   - childViewController: bottom sheet의 container view에 들어갈 view controller & scroll view를 포함하는 경우
    ///   - initialHeight: bottom sheet 초기 높이
    ///   - maxHeight: bottom sheet 최대 높이
    ///   - dim: background dim 처리 확인
    ///   - isTapDismiss: background가 tap으로 dismiss 되는지 확인
    ///   - dismissListener: bottom sheet가 dismiss 될때 수행되는 리스너, 해당 리스너는 dismissSheet의 completion handler 보다 우선순위가 낮음
    init(childViewController: UIViewController & ChangeableBottomSheetWithTableView, initialHeight: CGFloat, maxHeight: CGFloat, dim: Bool = true, isTapDismiss: Bool = true, dismissListener: BottomSheetDismissListenerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        childViewController.delegate = self
        self.childViewController = childViewController
        let bottomSafeAreaInsets = getBottomSafeAreaInsets()
        self.sheetHeight = maxHeight + bottomSafeAreaInsets
        self.initialHeight = initialHeight + bottomSafeAreaInsets
        self.dim = dim
        self.dimColor = (dim) ? UIColor(white: 0, alpha: Constant.maxDimAlpha) : UIColor.clear
        self.isTapDismiss = isTapDismiss
        self.availablePanning = true
        self.dismissListener = dismissListener
        self.modalPresentationStyle = .overFullScreen
        self.modalType = .changeable
    }

    /// bottom sheet initializer(높이 고정) + changeable(높이 변화 옵션) + scroll view가 childViewController에 있는 경우
    /// - Parameters:
    ///   - childViewController: bottom sheet의 container view에 들어갈 view controller & scroll view를 포함하는 경우
    ///   - initialHeight: bottom sheet 초기 높이
    ///   - maxHeight: bottom sheet 최대 높이
    ///   - dim: background dim 처리 확인
    ///   - isTapDismiss: background가 tap으로 dismiss 되는지 확인
    ///   - dismissListener: bottom sheet가 dismiss 될때 수행되는 리스너, 해당 리스너는 dismissSheet의 completion handler 보다 우선순위가 낮음
    init(childViewController: UIViewController & ChangeableBottomSheetWithCollectionView, initialHeight: CGFloat, maxHeight: CGFloat, dim: Bool = true, isTapDismiss: Bool = true, dismissListener: BottomSheetDismissListenerDelegate? = nil) {
        super.init(nibName: nil, bundle: nil)
        childViewController.delegate = self
        self.childViewController = childViewController
        let bottomSafeAreaInsets = getBottomSafeAreaInsets()
        self.sheetHeight = maxHeight + bottomSafeAreaInsets
        self.initialHeight = initialHeight + bottomSafeAreaInsets
        self.dim = dim
        self.dimColor = (dim) ? UIColor(white: 0, alpha: Constant.maxDimAlpha) : UIColor.clear
        self.isTapDismiss = isTapDismiss
        self.availablePanning = true
        self.dismissListener = dismissListener
        self.modalPresentationStyle = .overFullScreen
        self.modalType = .changeable
    }

    // MARK: - bottom sheet view의 container view 와 child view controller의 view UI를 setting
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setupContainerView()
        setupBackgroundView()
        setupChildViewController()
        setupGestureRecognizer()
        setupContainerHeight()
        self.view.layoutIfNeeded()
    }

    // MARK: - bottom sheet 등장 애니메이션, constraint를 조정하고 배경 dimm을 준다.
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sheetAppearAnimation(completion: showCompletion)
    }

    /// bottom sheet 등장 애니메이션
    /// - Parameter completion: show complete closure
    private func sheetAppearAnimation(completion: CommonFuncType? = nil) {
        topConstraint.constant = (modalType == .changeable) ? -self.initialHeight : -self.sheetHeight
        UIView.animate(withDuration: Constant.delay, delay: 0, options: [.curveEaseOut], animations: {
            // 호출 Interaction: 올라올 때 빠르게 시작해서 점점 속도가 주는 형태
            self.view.backgroundColor = self.dimColor
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if let completion = completion {
                completion()
            }
        })
    }

    // MARK: - bottom sheet의 container view의 초기 layout을 setting(바닥에서 나오기 전)
    private func setupContainerView() {
        self.view.addSubview(self.containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        heightConstraint = containerView.heightAnchor.constraint(equalToConstant: self.sheetHeight) // 바텀시트 높이를 동적으로 변화를 주기 위해
        topConstraint = containerView.topAnchor.constraint(equalTo: self.view.bottomAnchor) // top constraint는 애니메이션을 주기 위하여 따로 변수를 선언해서 사용
        heightConstraint.isActive = true
        topConstraint.isActive = true
    }

    // MARK: - child view controller를 현재 view controller의 자식 view로 추가 하고 해당 view를 container view와 동일하게 setting
    private func setupChildViewController() {
        addChild(self.childViewController)
        containerView.addSubview(self.childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        childViewController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        childViewController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
    }

    // MARK: - dimm 효과를 주고 tap시 dismiss가 될 공간을 setting, 해당 뷰 tap시 dismiss가 될 수 있게 한다.
    private func setupBackgroundView() {
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        backgroundView.backgroundColor = .clear
    }

    // MARK: - 바텀시트 높이가 유동적인 경우 높이를 계산한다
    private func setupContainerHeight() {
        if modalType == .flexible, let flexibleBottomSheet = childViewController as? FlexibleBottomSheetDelegate {
            var contentViewHeight = flexibleBottomSheet.bottomSheetContentView?.frame.size.height ?? 0
            let maxHeight = self.view.bounds.height - UIApplication.shared.statusBarFrame.height
            if contentViewHeight > maxHeight { // view 최대 높이보다 큰 경우
                contentViewHeight = maxHeight
            }
            sheetHeight = noAddBottomSafeArea ? contentViewHeight : contentViewHeight + getBottomSafeAreaInsets()
            heightConstraint.constant = sheetHeight
        }
    }

    // MARK: - Gesture Recognizer 등록
    private func setupGestureRecognizer() {
        if isTapDismiss {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapBackgroundView))
            backgroundView.addGestureRecognizer(tapGestureRecognizer) // background tap gesture 등록
        }
        if availablePanning {
            let containerViewGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
            containerView.addGestureRecognizer(containerViewGestureRecognizer)    // bottom sheet 전체 영역 gesture 추가
        }
    }

    // MARK: - UITapGestureRecognizer의 selector에 인자로 줄 objc 함수
    @objc func tapBackgroundView() {
        self.dismissSheet()
    }

    // MARK: Bottom Sheet를 show
    /// Bottom Sheet를 show
    /// - Parameters:
    ///   - presentView: Bottom Sheet를 띄우는 UIViewController
    ///   - completion: UIViewController present 함수의 completion handler
    @objc public func show(presentView: UIViewController, completion: CommonFuncType? = nil) {
        self.showCompletion = completion
        presentView.present(self, animated: false, completion: nil)
    }

    /// Bottom Sheet를 네비게이션 stack에서 show
    /// - Parameters:
    ///   - presentView: Bottom Sheet를 띄우는 UIViewController
    ///   - navigationController: BottomSheet를 rootViewController로 가지고 있는 UINavigationController
    ///   - completion: UINavigationController present 함수의 completion handler
    public func showByNavi(presentView: UIViewController, navigationController: UINavigationController, completion: CommonFuncType? = nil) {
        self.showCompletion = completion
        navigationController.modalPresentationStyle = .overFullScreen
        presentView.present(navigationController, animated: false, completion: nil)
    }

    // MARK: - bottom sheet를 dismiss
    /**
     bottom sheet dismiss
     - Parameter: view의 dismiss closure
     */
    @objc public func dismissSheet(completion: CommonFuncType? = nil) {
        topConstraint.constant = getBottomSafeAreaInsets()
        childViewController.view.endEditing(true) // dismiss시 UITextField end editing

        UIView.animate(withDuration: Constant.delay, delay: 0, options: [.curveEaseOut], animations: {
            // 종료 Interaction: 내려갈 때 빠르게 시작해서 점점 속도가 줄면서 사라지는 형태
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { _ in
            self.dismiss(animated: false) {
                guard let completion = completion else { // completion 함수가 없으면 dismiss listener의 onDismiss 로직 수행
                    self.dismissListener?.completeDismissBottomSheet()
                    return
                }
                completion()
            }
        })
    }

    /// bottom sheet 높이를 변경
    /// - Parameter height: 변경 할 높이
    @objc public func resizeSheet(height: CGFloat) {
        topConstraint.constant = -height
        heightConstraint.constant = height
        initialHeight = height
        sheetHeight = height
        isExpand = true
        UIView.animate(withDuration: Constant.delay, delay: 0, options: [.curveEaseOut], animations: {
            self.view.layoutIfNeeded()
        })
    }

    // MARK: pan gesture 로직 구현
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        isKeyboardShow ? keyboardPanGesture(gesture) : defaultPanGesture(gesture)
    }

    // MARK: 기본 pan gesture 로직 구현
    private func defaultPanGesture(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view) // panning위치

        let maxHeight = sheetHeight
        var newHeight = (modalType == .changeable) ? initialHeight - point.y : sheetHeight - point.y // 실시간으로 변하는 bottom sheet 높이

        if newHeight > maxHeight {
            newHeight = maxHeight
        }

        if gesture.state == .began {
            self.view.endEditing(true)
        } else if gesture.state == .cancelled || gesture.state == .failed { // gesture가 중간에 중단되거나 recognizer가 일치 하지 않는 경우
            dismissSheet()
        } else if gesture.state == .ended { // gesture가 종료된 경우
            let velocity = gesture.velocity(in: self.view).y // 종료 시 panning 속도 확인
            if velocity > Constant.flickingVelocity { // flicking이 아래로 발생한 경우
                dismissSheet()
            } else if velocity < -Constant.flickingVelocity { // flicking이 위로 발생한 경우
                (modalType == .changeable) ? resizeSheet(height: self.sheetHeight) : sheetAppearAnimation()
            } else if newHeight <= initialHeight/2 { // 절반 이상 panning된 경우
                dismissSheet()
            } else if newHeight > initialHeight {
                resizeSheet(height: self.sheetHeight)
            } else { // 절반 이하로 panning된 경우
                sheetAppearAnimation()
            }
        } else if gesture.state == .changed { // gesture가 진행 중
            topConstraint.constant = -newHeight
            if !dim {    // dim 처리 X
                self.view.backgroundColor = .clear
            } else if modalType == .changeable, newHeight >= initialHeight {    // mode changeable, panning 한 높이가 초기 높이보다 높은 경우
                self.view.backgroundColor = UIColor(white: 0, alpha: Constant.maxDimAlpha)
            } else if modalType == .changeable, newHeight < initialHeight {        // mode changeable, panning 한 높이가 초기보다 낮은 경우
                self.view.backgroundColor = UIColor(white: 0, alpha: Constant.maxDimAlpha * (newHeight/initialHeight))
            } else {    // mode fixed, flexible
                self.view.backgroundColor = UIColor(white: 0, alpha: Constant.maxDimAlpha * (newHeight/maxHeight))
            }
        }
    }

    // MARK: 키보드가 발생한 경우 pan gesture 로직 구현
    private func keyboardPanGesture(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {    // 이체 "받는사람" 바텀시트에서만 panning이 발생할때 키보드를 내려주자
            self.view.endEditing(true)
        } else if gesture.state == .cancelled || gesture.state == .failed { // gesture가 중간에 중단되거나 recognizer가 일치 하지 않는 경우
            dismissSheet()
        } else if gesture.state == .ended { // gesture가 종료된 경우
            let velocity = gesture.velocity(in: self.view).y // 종료 시 panning 속도 확인
            if isKeyboardShow && velocity > Constant.flickingVelocity {
                dismissSheet()
                isKeyboardShow = false
                return
            }
        }
    }

    // MARK: - return Bottom SafeAreaInsets
    /// Bottom SafeAreaInsets을 반환하는 함수
    private func getBottomSafeAreaInsets() -> CGFloat {
        var bottomSafeArea: CGFloat = 0
        if #available(iOS 11.0, *) {
            bottomSafeArea = getKeyWindow()?.safeAreaInsets.bottom ?? 0 // iOS 11 이상에서만 값을 가져온다.
        }
        return bottomSafeArea
    }
}

// MARK: - BottomSheet 관련 extension 로직
extension UIViewController {
    /// bottom sheet 부모뷰 return
    var bottomSheet: BottomSheet? {
        if var topController = getKeyWindow()?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            if let bottomSheet = topController as? BottomSheet {
                return bottomSheet
            } else if
                let navigationController = topController as? UINavigationController,
                let bottomSheet = navigationController.viewControllers.first as? BottomSheet {
                return bottomSheet
            }
        }
        return nil
    }

    // MARK: - return KeyWindow
    func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        } else {
            window = UIApplication.shared.keyWindow
        }
        return window
    }
}

extension BottomSheet: ChangeableScrollContentsDelegate {
    func contentsScrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y

        if isExpand {
            if offset <= 0.0 || initialHeight > -topConstraint.constant {
                scrollView.setContentOffset(.zero, animated: false)
                defaultPanGesture(scrollView.panGestureRecognizer)
            }
        } else {
            scrollView.setContentOffset(.zero, animated: false)
            defaultPanGesture(scrollView.panGestureRecognizer)
        }
    }

    func contentsScrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.showsVerticalScrollIndicator = isExpand
    }

    func contentsScrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offset = scrollView.contentOffset.y

        if offset == 0 {
            defaultPanGesture(scrollView.panGestureRecognizer)
        }
    }
}
