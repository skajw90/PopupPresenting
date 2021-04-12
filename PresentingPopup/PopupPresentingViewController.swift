//
//  PopupPresentViewController.swift
//
//  Created by Jiwon Nam on 2021/03/22.
//

import UIKit

protocol PresentingViewControllerDelegate: class {
    func dismiss(_ controller: PopupPresentViewController, animated: Bool, action: PresentingButtonActionType, data: Any?)
}

protocol PresentingViewControllerDataSource: class {
    func getData() -> Any?
}

class PopupPresentViewController: UIViewController {
    var style: PresentingStyle = .none
    weak var dataSource: PresentingViewControllerDataSource?
    weak var delegate: PresentingViewControllerDelegate?
    var contentView: UIView!
    var contentViewBottomConstraint: NSLayoutConstraint!
    
    init(style: PresentingStyle) {
        self.style = style  // by style select view itself
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTapped))
        view.addGestureRecognizer(gesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler))
        contentView.addGestureRecognizer(panGesture)
    }
    
    @objc private func backgroundDidTapped(gesture: UITapGestureRecognizer) {
        guard let frame = contentView?.frame, style.isForceQuitValid else { return }
        let location = gesture.location(in: view)
        if !frame.contains(location) {
            delegate?.dismiss(self, animated: true, action: .skip, data: nil)
        }
    }
    
    @objc private func panGestureHandler(gesture: UIPanGestureRecognizer) {
        if !style.isForceQuitValid { return }
        let velocity = gesture.velocity(in: contentView).y
        let direction = velocity / abs(velocity)
        let state = gesture.state
        let contentHeight = contentView.frame.height
        let spacing = contentViewBottomConstraint.constant + velocity * 0.01
        contentViewBottomConstraint.constant = max(0, spacing)
        if state == .ended {
            if abs(velocity) > 500 {
                if direction > 0 {
                    delegate?.dismiss(self, animated: true, action: .skip, data: nil)
                }
                else {
                    contentViewBottomConstraint.constant = 0
                }
            }
            else {
                if contentViewBottomConstraint.constant <= contentHeight / 2 {
                    contentViewBottomConstraint.constant = 0
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
                else {
                    delegate?.dismiss(self, animated: true, action: .skip, data: nil)
                }
            }
        }
        
    }
    
    private func configuration() {
        let currentView = style.view
        currentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentView)
        (currentView as? AbstractPresentingView)?.getData(constant: style.constantData, data: dataSource?.getData())
        (currentView as? AbstractPresentingView)?.setDelegate(self)
        currentView.layer.cornerRadius = 10
        currentView.layer.masksToBounds = true
        currentView.backgroundColor = .white
        currentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentViewBottomConstraint = NSLayoutConstraint(item: currentView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([
            currentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor),
            contentViewBottomConstraint
        ])
        contentView = currentView
    }
}

extension PopupPresentViewController: PopupViewActionDelegate {
    @objc func buttonAction(actionType: PresentingButtonActionType) {
        delegate?.dismiss(self, animated: true, action: actionType, data: nil)
    }
    /// optional if pop up view has list to select
    @objc func selectedItem(data: Any?) {
        delegate?.dismiss(self, animated: true, action: .none, data: data)
    }
}
