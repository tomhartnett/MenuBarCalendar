//
//  MonthCalendar.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

struct MonthCalendar: View {
    @EnvironmentObject var appContext: AppContext

    @State private var model = Model(Date())

    let rowHeight: CGFloat = 25

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    changeMonth(-1)
                }, label: {
                    Image(systemName: "chevron.left")
                })

                Spacer()

                Text(model.title)
                    .font(.title)

                Spacer()

                Button(action: {
                    changeMonth(1)
                }, label: {
                    Image(systemName: "chevron.right")
                })
            }
            .padding(.top)

            HStack {
                ForEach(model.headers) { header in
                    Text(header.daySymbol)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
            }
            .frame(height: rowHeight)

            ForEach(model.weeks) { week in
                HStack {
                    ForEach(week.days) { day in
                        ZStack {
                            if day.isToday {
                                Circle()
                            } else {
                                EmptyView()
                            }

                            Text("\(day.dayOfMonth)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(day.isInMonth ? day.isToday ? Color(nsColor: .windowBackgroundColor) : .primary : .secondary)
                                .italic(!day.isInMonth)
                        }
                    }
                }
                .frame(height: rowHeight)
            }
        }
        .onReceive(appContext.$selectedDate) { date in
            guard date != nil else { return }
            model = Model(date!)
        }
    }

    func changeMonth(_ increment: Int) {
        let dateInterval = Calendar.current.dateInterval(of: .month, for: model.date)!
        let newDate = Calendar.current.date(byAdding: .month, value: increment, to: dateInterval.start)!
        model = Model(newDate)
    }
}

extension MonthCalendar {
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

        init(_ date: Date, isInMonth: Bool, isToday: Bool) {
            self.date = date
            let comps = Calendar.current.dateComponents([.day, .month, .year], from: date)
            self.dayOfMonth = comps.day ?? 0
            self.month = comps.month ?? 0
            self.year = comps.year ?? 0
            self.isInMonth = isInMonth
            self.isToday = isToday
        }
    }

    struct Model {
        let date: Date

        let title: String

        let headers: [Header] = [
            .init(daySymbol: "Sun"),
            .init(daySymbol: "Mon"),
            .init(daySymbol: "Tue"),
            .init(daySymbol: "Wed"),
            .init(daySymbol: "Thu"),
            .init(daySymbol: "Fri"),
            .init(daySymbol: "Sat"),
        ]

        var weeks: [Week] = []

        init(_ date: Date) {
            self.date = date

            let monthInterval = Calendar.current.dateInterval(of: .month, for: date)!
            let firstWeek = Calendar.current.dateInterval(of: .weekOfYear, for: monthInterval.start)!
            let lastWeek = Calendar.current.dateInterval(of: .weekOfYear, for: monthInterval.end.addingTimeInterval(-1))!

            var loopDate = firstWeek.start
            while loopDate < lastWeek.end {
                let weekInterval = Calendar.current.dateInterval(of: .weekOfYear, for: loopDate)!
                var dayDate = weekInterval.start
                var tempDays = [Day]()
                while dayDate < weekInterval.end {
                    let day = Day(dayDate,
                                  isInMonth: Calendar.current.isDate(dayDate, equalTo: date, toGranularity: .month),
                                  isToday: Calendar.current.isDateInToday(dayDate))
                    tempDays.append(day)

                    dayDate = Calendar.current.date(byAdding: .day, value: 1, to: dayDate)!
                }

                self.weeks.append(Week(days: tempDays))

                tempDays.removeAll()

                loopDate = weekInterval.end
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM yyyy"
            self.title = formatter.string(from: date)
        }
    }
}

struct MonthCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendar()
            .frame(width: 300)
    }
}
