//
//  MonthCalendar.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

struct MonthCalendarView: View {
    @EnvironmentObject var context: AppContext

    @EnvironmentObject var viewModel: MonthViewModel

    let rowHeight: CGFloat = 25

    var body: some View {
        VStack {
            HStack {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.title)

                    Spacer()
                }
                .frame(width: 22)
                .contentShape(Rectangle())
                .padding(.leading, 8)
                .onTapGesture {
                    viewModel.changeMonth(-1)
                }

                Spacer()

                Text(viewModel.title)
                    .font(.title)

                Spacer()

                HStack {
                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.title)
                }
                .frame(width: 22)
                .contentShape(Rectangle())
                .padding(.trailing, 8)
                .onTapGesture {
                    viewModel.changeMonth(1)
                }
            }

            HStack {
                ForEach(viewModel.headers) { header in
                    Text(header.daySymbol)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
            }
            .frame(height: rowHeight)

            ForEach(viewModel.weeks) { week in
                HStack {
                    ForEach(week.days) { day in
                        DayView(day: day)
                    }
                }
                .frame(height: rowHeight)
            }
        }
        .onReceive(context.$selectedDate) { date in
            viewModel.selectedDate = date
        }
    }
}

#Preview {
    let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
    let context = AppContext(date: today)
    let viewModel = MonthViewModel(date: today)

    return MonthCalendarView()
        .environmentObject(context)
        .environmentObject(viewModel)
        .frame(width: 300, height: 300)
}
