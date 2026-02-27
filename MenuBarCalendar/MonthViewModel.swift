//
//  MonthViewModel.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/26/23.
//

import Combine
import Foundation

final class MonthViewModel: ObservableObject {
    @Published var title = ""
    @Published var weeks = [Week]()

    var headers: [Header] = []

    var selectedDate = Date() {
        didSet {
            if selectedDate != oldValue {
                computeMonth()
            }
        }
    }

    init() {
        computeHeaders()
        startObserving()
    }

    deinit {
        stopObserving()
    }

    private var observer: NSObjectProtocol?

    private var titleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private var relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter
    }()

    func changeMonth(_ increment: Int) {
        let calendar = Calendar.autoupdatingCurrent
        let dateInterval = calendar.dateInterval(of: .month, for: selectedDate)!
        let newDate = calendar.date(byAdding: .month, value: increment, to: dateInterval.start)!
        selectedDate = newDate
    }

    private func computeHeaders() {
        let calendar = Calendar.autoupdatingCurrent
        let firstWeekday = calendar.firstWeekday - 1
        let symbols = calendar.shortWeekdaySymbols

        let reorderedDays = symbols.suffix(from: firstWeekday) + symbols.prefix(firstWeekday)
        headers = reorderedDays.map { Header(daySymbol: $0) }
    }

    private func computeMonth() {
        let calendar = Calendar.autoupdatingCurrent
        let monthInterval = calendar.dateInterval(of: .month, for: selectedDate)!
        let today = calendar.startOfDay(for: Date())

        let lastWeekdayOfCalendar: Int
        if calendar.firstWeekday == 1 {
            // If first weekday is Sunday, then last weekday is Saturday (7).
            lastWeekdayOfCalendar = 7
        } else {
            // If first weekday is not Sunday, then last weekday is calendar.firstWeekday - 1. Strange but true.
            lastWeekdayOfCalendar = calendar.firstWeekday - 1
        }

        // Determine the first week to show for the month. It will include some days from the previous month.
        var firstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)!
        let firstWeekdayOfMonth = calendar.dateComponents([.weekday], from: firstWeek.start).weekday!
        let firstWeekdayIsInMonth = calendar.isDate(firstWeek.start, equalTo: selectedDate, toGranularity: .month)
        if firstWeekdayIsInMonth && firstWeekdayOfMonth == calendar.firstWeekday {
            // If the first day of month is also first day of week, then show previous week for "padding".
            // Adding -1 seconds will get dateInterval of the previous week.
            firstWeek = calendar.dateInterval(of: .weekOfYear, for: firstWeek.start.addingTimeInterval(-1))!
        }

        // Determine the last week to show for the month. It will include some days from the next month.
        var lastWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.end.addingTimeInterval(-1))!
        let lastWeekdayOfMonth = calendar.dateComponents([.weekday], from: lastWeek.end.addingTimeInterval(-1)).weekday!
        let lastWeekdayIsInMonth = calendar.isDate(lastWeek.end.addingTimeInterval(-1), equalTo: selectedDate, toGranularity: .month)
        if lastWeekdayIsInMonth && lastWeekdayOfMonth == lastWeekdayOfCalendar {
            // If last day of month is also last day of week, then show an extra row of dates for "padding".
            // lastWeek.end is exclusive upper bound, so it will get dateInterval of the following week.
            lastWeek = calendar.dateInterval(of: .weekOfYear, for: lastWeek.end)!
        }

        var loopDate = firstWeek.start
        var tempWeeks = [Week]()
        while loopDate < lastWeek.end {
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: loopDate)!
            var dayDate = weekInterval.start
            var tempDays = [Day]()
            while dayDate < weekInterval.end {

                let helpText = relativeFormatter.localizedString(for: dayDate, relativeTo: today)

                let day = Day(
                    dayDate,
                    isInMonth: calendar.isDate(dayDate, equalTo: selectedDate, toGranularity: .month),
                    isToday: calendar.isDateInToday(dayDate),
                    helpText: helpText
                )
                
                tempDays.append(day)

                dayDate = calendar.date(byAdding: .day, value: 1, to: dayDate)!
            }

            tempWeeks.append(Week(days: tempDays))

            tempDays.removeAll()

            loopDate = weekInterval.end
        }

        DispatchQueue.main.async { [unowned self] in
            self.title = self.titleFormatter.string(from: self.selectedDate)
            self.weeks = tempWeeks
        }
    }

    private func startObserving() {
        observer = NotificationCenter.default.addObserver(
            forName: NSLocale.currentLocaleDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.computeHeaders()
        }
    }

    private func stopObserving() {
        if let observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}

extension MonthViewModel {
    struct Header: Identifiable {
        var id = UUID()
        var daySymbol: String
    }

    struct Week: Identifiable {
        var id = UUID()
        var days: [Day]
    }

    struct Day: Identifiable {
        var id = UUID()
        var date: Date
        var dayOfMonth: Int
        var month: Int
        var year: Int
        var isInMonth: Bool
        var isToday: Bool
        var helpText: String

        init(_ date: Date, isInMonth: Bool, isToday: Bool, helpText: String) {
            self.date = date
            let comps = Calendar.autoupdatingCurrent.dateComponents([.day, .month, .year], from: date)
            self.dayOfMonth = comps.day ?? 0
            self.month = comps.month ?? 0
            self.year = comps.year ?? 0
            self.isInMonth = isInMonth
            self.isToday = isToday
            self.helpText = helpText
        }
    }
}
