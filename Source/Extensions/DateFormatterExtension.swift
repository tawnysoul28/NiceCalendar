//
//  DateFormatterExtension.swift
//  CalendarTest
//
//  Created by Асанцев Владимир Дмитриевич on 14.07.2021.
//

import Foundation

extension DateFormatter {
    /// The shared date formatter object with "ru_RU" locale
    static let shared: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
}
