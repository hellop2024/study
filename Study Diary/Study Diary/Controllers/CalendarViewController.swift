//
//  CalendarViewController.swift
//  Study Diary
//
//  Created by YS P on 5/7/24.
//

import UIKit

class CalendarViewController: UIViewController {

    lazy var calendarView: UICalendarView = {
            let view = UICalendarView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.wantsDateDecorations = true
            return view
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calendarView)
               applyConstraints()
    }
    
    func applyConstraints() {
            let constraints = [
                calendarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                calendarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
    }
