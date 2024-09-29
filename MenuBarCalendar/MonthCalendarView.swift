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
                        ZStack {
                            if day.isToday {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(Color.accentColor.opacity(0.75))
                            } else {
                                EmptyView()
                            }

                            Text("\(day.dayOfMonth)")
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(computeForegroundColor(for: day))
                                .italic(!day.isInMonth)
                                .fontWeight(day.isInMonth ? .medium : .regular)
                                .help(day.helpText)
                        }
                    }
                }
                .frame(height: rowHeight)
            }
        }
        .onReceive(context.$selectedDate) { date in
            guard date != nil else { return }
            viewModel.selectedDate = date!
        }
    }

    func computeForegroundColor(for day: MonthViewModel.Day) -> Color {
        if day.isToday {
            return Color(nsColor: .white)
        } else if day.isInMonth {
            return Color.primary
        } else {
            return Color.secondary
        }
    }
}

struct MonthCalendar_Previews: PreviewProvider {
    static var previews: some View {
        let context = AppContext()
        context.today()

        return MonthCalendarView()
            .environmentObject(context)
            .frame(width: 344)
    }
}
