//
//  HomeViewController.swift
//  CalendarTest
//
//  Created by Асанцев Владимир Дмитриевич on 15.07.2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let calendarButton: UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        calendarButton.backgroundColor = UIColor.systemBlue
        calendarButton.setTitle("Open calendar", for: .normal)
        calendarButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(calendarButton)
        
        view.addSubview(calendarButton)
        
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarButton.widthAnchor.constraint(equalToConstant: 250),
            calendarButton.heightAnchor.constraint(equalToConstant: 100),
            calendarButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            calendarButton.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    @objc func buttonAction(sender: UIButton) {
        let calendarVC = CalendarViewController()
        navigationController?.present(calendarVC, animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    
}
