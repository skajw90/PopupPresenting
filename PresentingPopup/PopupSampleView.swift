//
//  PopupSampleView.swift
//
//  Created by Jiwon Nam on 2021/01/06.
//

import UIKit

class PopupSampleView: UIView, AbstractPresentingView {
    weak var delegate: PopupViewActionDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize:  18, weight: .bold)
        label.textColor = UIColor.black
        label.sizeToFit()
        addSubview(label)
        return label
    } ()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize:  14)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        addSubview(label)
        return label
    } ()
    
    lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.setTitle("확인", for: .normal)
        button.addTarget(self, action: #selector(confirmButtonDidTapped), for: .touchUpInside)
        addSubview(button)
        return button
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func confirmButtonDidTapped(sender: Any) {
        delegate?.buttonAction?(actionType: .next)
//        delegate?.buttonAction?(type: confirmButton.actionType)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18)
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            confirmButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//            confirmButton.setBottomConstraint(view: self, attributedTo: .bottom)
        ])
    }
    
    func getData(constant: Any?, data: Any?) {
        titleLabel.text = constant as? String
        descriptionLabel.text = data as? String
    }
    
    func setDelegate(_ controller: UIViewController) {
        delegate = controller as? PopupViewActionDelegate
    }
}
