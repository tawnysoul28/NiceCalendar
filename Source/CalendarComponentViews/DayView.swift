//
//  DayLabel.swift
//  CalendarTest
//
//  Created by Асанцев Владимир Дмитриевич on 14.07.2021.
//

import HorizonCalendar
import UIKit

final class DayView: UIView {

  // MARK: Lifecycle

  init(invariantViewProperties: InvariantViewProperties) {
    dayLabel = UILabel()
    dayLabel.font = invariantViewProperties.font
    dayLabel.textAlignment = invariantViewProperties.textAlignment
    dayLabel.textColor = invariantViewProperties.textColor

    super.init(frame: .zero)

    addSubview(dayLabel)

    layer.borderColor = invariantViewProperties.selectedColor.cgColor
    layer.borderWidth = invariantViewProperties.isSelectedStyle ? 2 : 0
    
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  var dayText: String {
    get { dayLabel.text ?? "" }
    set { dayLabel.text = newValue }
  }

  var dayAccessibilityText: String?

  var isHighlighted = false {
    didSet {
      updateHighlightIndicator()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    dayLabel.frame = bounds
    layer.cornerRadius = min(bounds.width, bounds.height) / 2
  }

  // MARK: Private

  private let dayLabel: UILabel

  private func updateHighlightIndicator() {
    backgroundColor = isHighlighted ? UIColor.red.withAlphaComponent(0.1) : .clear
  }

}

// MARK: UIAccessibility

extension DayView {

  override var isAccessibilityElement: Bool {
    get { true }
    set { }
  }

  override var accessibilityLabel: String? {
    get { dayAccessibilityText ?? dayText }
    set { }
  }

}

// MARK: CalendarItemViewRepresentable

extension DayView: CalendarItemViewRepresentable {

  struct InvariantViewProperties: Hashable {
    var font = UIFont.systemFont(ofSize: 18)
    var textAlignment = NSTextAlignment.center
    var textColor: UIColor
    var isSelectedStyle: Bool
    var selectedColor = UIColor.red
  }

  struct ViewModel: Equatable {
    let dayText: String
    let dayAccessibilityText: String?
    let isViewHighlighted: Bool
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayView
  {
    DayView(invariantViewProperties: invariantViewProperties)
  }

  static func setViewModel(_ viewModel: ViewModel, on view: DayView) {
    view.dayText = viewModel.dayText
    view.dayAccessibilityText = viewModel.dayAccessibilityText
    view.isHighlighted = viewModel.isViewHighlighted
  }

}

//struct DayView: CalendarItemViewRepresentable {
//
//  /// Properties that are set once when we initialize the view.
//  struct InvariantViewProperties: Hashable {
//    let font: UIFont
//    var textColor: UIColor
//    var backgroundColor: UIColor
//    let borderWidth: CGFloat = 0
//    let borderColor: CGColor = UIColor.clear.cgColor
//  }
//
//  /// Properties that will vary depending on the particular date being displayed.
//  struct ViewModel: Equatable {
//    let day: Day
//  }
//
//  static func makeView(
//    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
//    -> UILabel
//  {
//    let label = UILabel()
//
//    label.backgroundColor = invariantViewProperties.backgroundColor
//    label.font = invariantViewProperties.font
//    label.textColor = invariantViewProperties.textColor
//    label.layer.borderWidth = invariantViewProperties.borderWidth
//    label.layer.borderColor = invariantViewProperties.borderColor
//
//    label.textAlignment = .center
//    label.clipsToBounds = true
//    label.layer.cornerRadius = label.bounds.height / 2
//
//    return label
//  }
//
//  static func setViewModel(_ viewModel: ViewModel, on view: UILabel) {
//    view.text = "\(viewModel.day.day)"
//  }
//
//}
