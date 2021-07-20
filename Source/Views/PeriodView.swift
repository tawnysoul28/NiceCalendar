//
//  PeriodHeader.swift
//  CalendarTest
//
//  Created by Асанцев Владимир Дмитриевич on 15.07.2021.
//

import UIKit

final class PeriodView: UIView {
    
    private let cancelButton = UIButton()
    private let periodLabel = UILabel()
    private let confirmButton = UIButton()
    
    private let container = UIStackView()
    
    var isConfirmButtonEnabled: Bool = false {
        didSet {
            confirmButton.isEnabled = isConfirmButtonEnabled
            setNeedsLayout()
        }
    }
    
    var fromDate = Date()
    var toDate = Date()

    var cancelAction: (() -> Void)?
    var confirmAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.white

        periodLabel.font = UIFont.systemFont(ofSize: 17)
        periodLabel.textColor = UIColor.black
        periodLabel.text = "Период"
        periodLabel.layer.borderWidth = 0.5
        periodLabel.layer.borderColor = UIColor.red.cgColor

        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        cancelButton.setTitleColor(UIColor.blue, for: .normal)
        cancelButton.layer.borderWidth = 0.5
        cancelButton.layer.borderColor = UIColor.red.cgColor
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        confirmButton.setTitle("Применить", for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        confirmButton.setTitleColor(UIColor.blue, for: .normal)
        confirmButton.setTitleColor(UIColor.gray, for: .disabled)
        confirmButton.layer.borderWidth = 0.5
        confirmButton.layer.borderColor = UIColor.red.cgColor
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        
        confirmButton.isEnabled = false
        
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .equalCentering

        for view in [cancelButton, periodLabel, confirmButton] {
            container.addArrangedSubview(view)
        }
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(container)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
//            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func cancel() {
        cancelAction?()
    }

    @objc private func confirm() {
        confirmAction?()
    }
}

