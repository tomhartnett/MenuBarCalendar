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

    let headers: [Header] = [
        .init(daySymbol: "Sun"),
        .init(daySymbol: "Mon"),
        .init(daySymbol: "Tue"),
        .init(daySymbol: "Wed"),
        .init(daySymbol: "Thu"),
        .init(daySymbol: "Fri"),
        .init(daySymbol: "Sat"),
    ]

    var selectedDate = Date() {
        didSet {
            if selectedDate != oldValue {
                computeMonth()
            }
        }
    }

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

    private func computeMonth() {
        // TODO: avoid force-unwrapping of dates.
        let calendar = Calendar.autoupdatingCurrent
        let monthInterval = calendar.dateInterval(of: .month, for: selectedDate)!
        let firstWeek = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)!
        let firstDayOfLastWeek = calendar.date(byAdding: .weekOfYear, value: 5, to: firstWeek.start)!
        let lastWeek = calendar.dateInterval(of: .weekOfYear, for: firstDayOfLastWeek)!

        var loopDate = firstWeek.start
        var tempWeeks = [Week]()
        while loopDate < lastWeek.end {
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: loopDate)!
            var dayDate = weekInterval.start
            var tempDays = [Day]()
            let now = Date()
            while dayDate < weekInterval.end {

                let components = calendar.dateComponents(
                    [.minute, .hour, .day],
                    from: now,
                    to: dayDate)

                let helpText: String
                if abs(dayDate.timeIntervalSince(now)) > 14 * 86_400 {
                    helpText = relativeFormatter.localizedString(for: dayDate, relativeTo: now)
                } else {
                    helpText = relativeFormatter.localizedString(from: components)
                }

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

        title = titleFormatter.string(from: selectedDate)
        weeks = tempWeeks
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
