//
//  ConfirmationView.swift
//  CalendarTest
//
//  Created by Асанцев Владимир Дмитриевич on 14.07.2021.
//

import UIKit

final class ConfirmationView: UIView {
    private let cancelButton = UIButton()
    private let dateLabel = UILabel()
    
    private let container = UIStackView()

    var dateText: String = " " {
        didSet {
            dateLabel.text = dateText
            setNeedsLayout()
        }
    }
    
    var isCancelButtonHidden: Bool = true {
        didSet {
            cancelButton.isHidden = isCancelButtonHidden
            setNeedsLayout()
        }
    }

    var cancelAction: (() -> Void)?
    var confirmAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.red.cgColor

        dateLabel.numberOfLines = 0
        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = UIColor.black
        dateLabel.layer.borderWidth = 0.5
        dateLabel.layer.borderColor = UIColor.red.cgColor
        
        dateLabel.text = "Выберите период"

        cancelButton.backgroundColor = UIColor.red
        cancelButton.setTitle("x", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.layer.cornerRadius = 12
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        addSubview(dateLabel)
        addSubview(cancelButton)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
//        container.axis = .horizontal
//        container.alignment = .leading
////        container.distribution = .fillProportionally
//        container.spacing = 12
//        container.layer.borderWidth = 1
//        container.layer.borderColor = UIColor.green.cgColor
        
//        container.contentMode = .left

//        for view in [dateLabel, cancelButton] {
//            container.addArrangedSubview(view)
//        }
//
//        container.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(container)

        NSLayoutConstraint.activate([
            
//            cancelButton.widthAnchor.constraint(equalToConstant: 24),
//            cancelButton.heightAnchor.constraint(equalToConstant: 24),
//
//            container.centerYAnchor.constraint(equalTo: centerYAnchor),
//            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            
//            container.topAnchor.constraint(equalTo: topAnchor),
//            container.leadingAnchor.constraint(equalTo: leadingAnchor),
//            container.trailingAnchor.constraint(greaterThanOrEqualTo: trailingAnchor),
//            container.bottomAnchor.constraint(equalTo: bottomAnchor)
            
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 12),
//            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 24),
            cancelButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func cancel() {
        cancelAction?()
    }

//    @objc private func confirm() {
//        confirmAction?()
//    }
}
