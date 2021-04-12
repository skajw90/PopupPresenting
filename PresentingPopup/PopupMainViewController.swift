//
//  PopupMainViewController.swift
//  PresentingPopup
//
//  Created by Jiwon Nam on 2021/04/12.
//

import UIKit
protocol AbstractPresentingView: class {
    func getData(constant: Any?, data: Any?)
    func setDelegate(_ controller: UIViewController)
}

@objc protocol PopupViewActionDelegate: class {
    @objc optional func buttonAction(actionType: PresentingButtonActionType)
    @objc optional func selectedItem(data: Any?)
}

protocol PopupViewControllerDelegate: class {
    func dismissWithData(_ controller: PopupViewController, actionType: PresentingButtonActionType, data: Any?)
}

protocol PopupViewControllerDataSource: class {
    func getData(style: PresentingStyle) -> Any?
}

class PopupViewController: UIViewController {
    var style: PresentingStyle = .none
    private var data: Any?
    weak var delegate: PopupViewControllerDelegate?
    weak var dataSource: PopupViewControllerDataSource?
    var bottomSpacing: CGFloat = 0
    var control: PopupPresentViewController?
    var destination: UIViewController?
    
    init(style: PresentingStyle,
         bottomSpacing: CGFloat = 0, destination: UIViewController?) {
        self.style = style  // by style select view itself
        self.bottomSpacing = bottomSpacing
        self.destination = destination
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7) // default
        view.addSubview(backgroundView)
        return backgroundView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = dataSource?.getData(style: style)
        backgroundView.frame = CGRect(origin: .zero,
                                      size: CGSize(width: view.frame.width,
                                                   height: view.frame.height - bottomSpacing))
        DispatchQueue.main.async {
            self.presentPopupView()
        }
    }
    
    private func presentPopupView() {
        control = PopupPresentViewController(style: style)
        control!.dataSource = self
        control!.delegate = self
        control!.modalPresentationStyle = .overCurrentContext
        self.parent?.present(control!, animated: true, completion: nil)
    }
}

extension PopupViewController: PresentingViewControllerDataSource, PresentingViewControllerDelegate {
    func dismiss(_ controller: PopupPresentViewController, animated: Bool, action: PresentingButtonActionType, data: Any?) {
        controller.dismiss(animated: animated, completion: {
            self.delegate?.dismissWithData(self, actionType: action, data: data)
        })
    }
    
    func getData() -> Any? {
        return data
    }
}
