//
//  CalendarViewController.swift
//  CalendarTest
//
//  Created by Асанцев Владимир Дмитриевич on 14.07.2021.
//

import UIKit
import HorizonCalendar

class CalendarViewController: UIViewController {
    
    private var calendar = Calendar.current
    
    private let confirmationView = ConfirmationView()
    private let periodView = PeriodView()
    private var confirmationViewTopConstraint = NSLayoutConstraint()
    
//    private var selectedDay: Day? {
//        didSet {
//            DateFormatter.shared.dateFormat = "dd.MM.yyyy"
//
//            if let components = selectedDay?.components,
//               let pickedDate = calendar.date(from: components) {
//                let stringDate = DateFormatter.shared.string(from: pickedDate)
////                let splitDate = stringDate.split(separator: " ")
////                let month = splitDate[0].capitalized
////                let day = splitDate[1]
////                let weekday = splitDate[2]
//                confirmationView.dateText = stringDate //"\(month) \(day)\n\(weekday)"
////                self.confirmationViewTopConstraint.constant = -120
//
//                UIView.animate(withDuration: 0.2) {
//                    self.view.layoutIfNeeded()
//                }
//            }
//        }
//    }

//    private var isConfirmed = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white

        calendar.locale = Locale(identifier: "ru_RU")

        configureHeader()
        configureConfirmation()
        configureCalendar()
    }
    
    private func configureHeader() {
        view.addSubview(periodView)

        periodView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            periodView.topAnchor.constraint(equalTo: view.topAnchor),
            periodView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            periodView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            periodView.heightAnchor.constraint(equalToConstant: 44)
        ])

        periodView.confirmAction = { [weak self] in
            guard let self = self else { return }
            
            let fromDate = self.periodView.fromDate
            let toDate = self.periodView.toDate
            
            print("From: \(fromDate) – To: \(toDate)")

//            self.isConfirmed = true
//            self.dismiss(animated: true)
        }

        periodView.cancelAction = { [weak self] in
            guard let self = self else { return }

//            self.selectedDay = nil
            self.dismiss(animated: true)
        }
    }
    
    private func configureConfirmation() {
        view.addSubview(confirmationView)

        confirmationView.translatesAutoresizingMaskIntoConstraints = false
//        confirmationViewTopConstraint = confirmationView.topAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            confirmationView.topAnchor.constraint(equalTo: periodView.bottomAnchor),
            confirmationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            confirmationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            confirmationView.heightAnchor.constraint(equalToConstant: 50)
        ])

//        confirmationView.confirmAction = { [weak self] in
//            guard let self = self else { return }
//
//            self.isConfirmed = true
//            self.dismiss(animated: true)
//        }

        confirmationView.cancelAction = { [weak self] in
            guard let self = self else { return }
            
            self.confirmationView.dateText = "Выберите период"
            
            self.calendarSelection = .none
            
            self.periodView.isConfirmButtonEnabled = false
            
            
            self.configureCalendar()
            
//            self.confirmationView.isCancelButtonHidden = true
//            self.selectedDay = nil
//            self.dismiss(animated: true)
        }
    }
    
    private func configureCalendar() {
        let calendarView = CalendarView(initialContent: makeContent())
        calendarView.backgroundColor = UIColor.white
        calendarView.layer.borderWidth = 1
        calendarView.layer.borderColor = UIColor.red.cgColor
        
        calendarView.scroll(
            toMonthContaining: Date(),
            scrollPosition: .firstFullyVisiblePosition,
            animated: false)
        
        view.addSubview(calendarView)

        calendarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: confirmationView.bottomAnchor, constant: 0),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self = self else { return }
            
            //запрет выделения дней в будущем
            if self.compareToNow(day) != .orderedAscending {
                return
            }
            
            switch self.calendarSelection {
            case .singleDay(let selectedDay):
                if day > selectedDay {
                    self.calendarSelection = .dayRange(selectedDay...day)
                } else {
                    self.calendarSelection = .singleDay(day)
                }
            case .none, .dayRange:
                self.calendarSelection = .singleDay(day)
            }
            
            calendarView.setContent(self.makeContent())
        }

//        calendarView.daySelectionHandler = { [weak self] day in
//            guard let self = self else { return }
//
//            if self.compareToNow(day) == .orderedAscending {
//                self.selectedDay = day
//            }
//
//            let newContent = self.makeContent()
//            calendarView.setContent(newContent)
//        }
    }

    private func makeContent() -> CalendarViewContent {
    
        //начальная дата
        let oneYearAgoDate = calendar.date(byAdding: .year, value: -1, to: Date())!
        
        //let endDate = Date(timeInterval: 60 * 60 * 24 * 365, since: Date())
        
//        let selectedDay = self.selectedDay
        
        //calendarSelection - то на какой день я тыкнул
        let calendarSelection = self.calendarSelection
        let dateRanges: Set<ClosedRange<Date>>
        var fromDateString = ""
        var toDateString = ""
        if
            case .dayRange(let dayRange) = calendarSelection,
            let lowerBound = calendar.date(from: dayRange.lowerBound.components),
            let upperBound = calendar.date(from: dayRange.upperBound.components)
        {
            dateRanges = [lowerBound...upperBound]
            
            self.periodView.fromDate = lowerBound
            self.periodView.toDate = upperBound
            
            fromDateString = DateFormatter.shared.string(from: lowerBound)
            toDateString = DateFormatter.shared.string(from: upperBound)
        } else {
            dateRanges = []
        }
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: oneYearAgoDate...Date(),
            monthsLayout: .vertical(options: VerticalMonthsLayoutOptions(pinDaysOfWeekToTop: true, alwaysShowCompleteBoundaryMonths: true)))
            
            .withDayItemModelProvider { [weak self] day in
                
                DateFormatter.shared.dateFormat = "dd.MM.yyyy"
                
                //проверка на выделение даты кружком (начальная/конечная дата диапозона)
                let isSelectedStyle: Bool
                
                switch calendarSelection {
                case .singleDay(let selectedDay):
                    isSelectedStyle = day == selectedDay
                    
                    if let pickedDate = self?.calendar.date(from: selectedDay.components) {
                        fromDateString = DateFormatter.shared.string(from: pickedDate)
                        self?.confirmationView.dateText = fromDateString
                    }
                    
                    self?.periodView.isConfirmButtonEnabled = false
                    
                    self?.confirmationView.isCancelButtonHidden = false
                
                case .dayRange(let selectedDayRange):
                    isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
                    
                    self?.confirmationView.dateText = "\(fromDateString) - \(toDateString)"
                    
                    self?.periodView.isConfirmButtonEnabled = true
                    
                    self?.confirmationView.isCancelButtonHidden = false
                    
                case .none:
                    isSelectedStyle = false
                    
                    self?.confirmationView.isCancelButtonHidden = true
                }
                
                let dayAccessibilityText: String?
                if let date = self?.calendar.date(from: day.components) {
                    dayAccessibilityText = DateFormatter.shared.string(from: date)
                } else {
                    dayAccessibilityText = nil
                }
                
                
                var invariantViewProperties = DayView.InvariantViewProperties(
                    font: UIFont.systemFont(ofSize: 18),
                    textColor: UIColor.black,
                    isSelectedStyle: isSelectedStyle
                )
                
                if self?.compareToNow(day) != .orderedAscending {
                    invariantViewProperties.textColor = UIColor.gray
                }
                
                return CalendarItemModel<DayView>(
                    invariantViewProperties: invariantViewProperties,
                    viewModel: .init(dayText: "\(day.day)", dayAccessibilityText: dayAccessibilityText, isViewHighlighted: isSelectedStyle))
            }
            
            .withDayRangeItemModelProvider(for: dateRanges) { dayRangeLayoutContext in
              CalendarItemModel<DayRangeIndicatorView>(
                invariantViewProperties: .init(),
                viewModel: .init(
                  framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
            }
            
//            .withDayItemModelProvider { day in
//                var invariantViewProperties = DayView.InvariantViewProperties(
//                    font: UIFont.systemFont(ofSize: 18),
//                    textColor: UIColor.black,
//                    backgroundColor: .clear
//                )
//
//                if day == selectedDay {
//                    invariantViewProperties.textColor = UIColor.white
//                    invariantViewProperties.backgroundColor = UIColor.blue
//                }
//
//                if self.compareToNow(day) != .orderedAscending {
//                    invariantViewProperties.textColor = UIColor.gray
//                }
//
//                return CalendarItemModel<DayView>(
//                    invariantViewProperties: invariantViewProperties,
//                    viewModel: .init(day: day)
//                )
//            }
            
            .withInterMonthSpacing(24) //вертикальный отступ от последнего числа месяца до хэдэра с следующим названием месяца
            .withVerticalDayMargin(8) //вертикальный отступ дней друг от друга
            .withHorizontalDayMargin(8) //горизонтальный отступ дней друг от друга
            
            .withMonthHeaderItemModelProvider { month in
                CalendarItemModel<MonthHeader>(
                    invariantViewProperties: .init(
                        font: UIFont.systemFont(ofSize: 22),
                        textColor: UIColor.black,
                        backgoundColor: .clear
                    ),
                    viewModel: .init(month: month)
                )
            }
            
            .withDayOfWeekItemModelProvider { _, dayOfWeekIndex  in
                CalendarItemModel<DayOfWeekRow>(
                    invariantViewProperties: .init(
                        font: UIFont.systemFont(ofSize: 18),
                        textColor: .darkGray,
                        backgroundColor: .clear),
                    viewModel: .init(dayOfWeekIndex: dayOfWeekIndex))
            }
            
            .withDaysOfTheWeekRowSeparator(options: .init(height: 1, color: UIColor.darkGray))
    }

    private func compareToNow(_ day: Day) -> ComparisonResult? {
        guard let calendarDay = calendar.date(from: day.components) else { return nil }

        let result = calendar.compare(calendarDay, to: Date(), toGranularity: .day)

        return result
    }
    
    // MARK: Private

    private enum CalendarSelection {
      case singleDay(Day)
      case dayRange(DayRange)
    }
    private var calendarSelection: CalendarSelection?
}


//import HorizonCalendar
//import UIKit
//
//// MARK: - DemoPickerViewController
//
//final class ViewController: UIViewController {
//
//  // MARK: Internal
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    title = "HorizonCalendar Example App"
//
//    if #available(iOS 13.0, *) {
//      view.backgroundColor = .systemBackground
//    } else {
//      view.backgroundColor = .white
//    }
//
//    view.addSubview(tableView)
//    view.addSubview(monthsLayoutPicker)
//
//    tableView.translatesAutoresizingMaskIntoConstraints = false
//    monthsLayoutPicker.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      monthsLayoutPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//      monthsLayoutPicker.topAnchor.constraint(
//        equalTo: view.layoutMarginsGuide.topAnchor,
//        constant: 8),
//
//      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      tableView.topAnchor.constraint(equalTo: monthsLayoutPicker.bottomAnchor, constant: 8),
//      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//    ])
//  }
//
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(true)
//
//    if let selectedIndexPath = tableView.indexPathForSelectedRow {
//      tableView.deselectRow(at: selectedIndexPath, animated: animated)
//    }
//  }
//
//  // MARK: Private
//
//  private let verticalDemoDestinations: [(name: String, destinationType: DemoViewController.Type)] = [
//    ("Single Day Selection", SingleDaySelectionDemoViewController.self),
//    ("Day Range Selection", DayRangeSelectionDemoViewController.self),
//    ("Selected Day Tooltip", SelectedDayTooltipDemoViewController.self),
//    ("Large Day Range", LargeDayRangeDemoViewController.self),
//    ("Scroll to Day With Animation", ScrollToDayWithAnimationDemoViewController.self),
//    ("Partial Month Visibility", PartialMonthVisibilityDemoViewController.self),
//  ]
//
//  private let horizontalDemoDestinations: [(name: String, destinationType: DemoViewController.Type)] = [
//    ("Single Day Selection", SingleDaySelectionDemoViewController.self),
//    ("Day Range Selection", DayRangeSelectionDemoViewController.self),
//    ("Selected Day Tooltip", SelectedDayTooltipDemoViewController.self),
//    ("Large Day Range", LargeDayRangeDemoViewController.self),
//    ("Scroll to Day With Animation", ScrollToDayWithAnimationDemoViewController.self),
//  ]
//
//  private lazy var tableView: UITableView = {
//    let tableView = UITableView(frame: .zero)
//    tableView.dataSource = self
//    tableView.delegate = self
//    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//    return tableView
//  }()
//
//  private lazy var monthsLayoutPicker: UISegmentedControl = {
//    let segmentedControl = UISegmentedControl(items: ["Vertical", "Horizontal"])
//    segmentedControl.selectedSegmentIndex = 0
//    segmentedControl.addTarget(
//      self,
//      action: #selector(monthsLayoutPickerValueChanged),
//      for: .valueChanged)
//    return segmentedControl
//  }()
//
//  @objc
//  private func monthsLayoutPickerValueChanged() {
//    tableView.reloadData()
//  }
//
//}
//
//// MARK: - UITableViewDataSource
//
//extension ViewController: UITableViewDataSource {
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    monthsLayoutPicker.selectedSegmentIndex == 0
//      ? verticalDemoDestinations.count
//      : horizontalDemoDestinations.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//
//    let demoDestination = monthsLayoutPicker.selectedSegmentIndex == 0
//      ? verticalDemoDestinations[indexPath.item]
//      : horizontalDemoDestinations[indexPath.item]
//    cell.textLabel?.text = demoDestination.name
//
//    return cell
//  }
//
//}
//
//// MARK: - UITableViewDelegate
//
//extension ViewController: UITableViewDelegate {
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let demoDestination = monthsLayoutPicker.selectedSegmentIndex == 0
//      ? verticalDemoDestinations[indexPath.item]
//      : horizontalDemoDestinations[indexPath.item]
//
//    let demoViewController = demoDestination.destinationType.init(
//      monthsLayout: monthsLayoutPicker.selectedSegmentIndex == 0
//        ? .vertical(
//          options: VerticalMonthsLayoutOptions(
//            pinDaysOfWeekToTop: true,
//            alwaysShowCompleteBoundaryMonths: false))
//        : .horizontal(
//          options: HorizontalMonthsLayoutOptions(
//            maximumFullyVisibleMonths: 1.5,
//            scrollingBehavior: .paginatedScrolling(
//              .init(
//                restingPosition: .atLeadingEdgeOfEachMonth,
//                restingAffinity: .atPositionsClosestToTargetOffset)))))
//
//    navigationController?.pushViewController(demoViewController, animated: true)
//  }
//
//}

