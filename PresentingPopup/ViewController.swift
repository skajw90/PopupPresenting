//
//  ViewController.swift
//
//  Created by Jiwon Nam on 2021/04/12.
//

import UIKit

class ViewController: UIViewController {

    lazy var popup_1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("popup_1 button", for: .normal)
        button.addTarget(self, action: #selector(popup_1DidTapped), for: .touchUpInside)
        view.addSubview(button)
        return button
    } ()
    
    lazy var popup_2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("string list button", for: .normal)
        button.addTarget(self, action: #selector(popup_2DidTapped), for: .touchUpInside)
        view.addSubview(button)
        return button
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
    }

    @objc private func popup_1DidTapped() {
        presentPopupView(style: .none)
    }
    
    @objc private func popup_2DidTapped() {
        
    }
    
    func presentPopupView(style: PresentingStyle, destination: UIViewController? = nil) {
        let control = PopupViewController(style: style, destination: destination)
        control.delegate = self
        control.dataSource = self
        
        view.addSubview(control.view)
        addChild(control)
        control.willMove(toParent: self)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            popup_1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popup_1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
        
        NSLayoutConstraint.activate([
            popup_2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popup_2.topAnchor.constraint(equalTo: popup_1.bottomAnchor, constant: 100)
        ])
    }

}

extension ViewController: PopupViewControllerDataSource, PopupViewControllerDelegate {
    func getData(style: PresentingStyle) -> Any? {
        return "TITLE"
    }
    
    func dismissWithData(_ controller: PopupViewController, actionType: PresentingButtonActionType, data: Any?) {
        let style = controller.style
        let actionType = actionType
        let data = data
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    
}
