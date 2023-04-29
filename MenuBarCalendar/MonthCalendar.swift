//
//  MonthCalendar.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

struct MonthCalendar: View {
    @EnvironmentObject var appContext: AppContext

    @StateObject private var viewModel = MonthViewModel()

    let rowHeight: CGFloat = 25

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.changeMonth(-1)
                }, label: {
                    Image(systemName: "chevron.left")
                })

                Spacer()

                Text(viewModel.title)
                    .font(.title)

                Spacer()

                Button(action: {
                    viewModel.changeMonth(1)
                }, label: {
                    Image(systemName: "chevron.right")
                })
            }
            .padding(.top)

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
                            } else {
                                EmptyView()
                            }

                            Text("\(day.dayOfMonth)")
                                .frame(maxWidth: .infinity)
                                .foregroundColor(day.isInMonth ? day.isToday ? Color(nsColor: .windowBackgroundColor) : .primary : .secondary)
                                .italic(!day.isInMonth)
                                .help(day.helpText)
                        }
                    }
                }
                .frame(height: rowHeight)
            }
        }
        .onReceive(appContext.$selectedDate) { date in
            guard date != nil else { return }
            viewModel.selectedDate = date!
        }
    }
}

struct MonthCalendar_Previews: PreviewProvider {
    static var previews: some View {
        MonthCalendar()
            .frame(width: 300)
    }
}
