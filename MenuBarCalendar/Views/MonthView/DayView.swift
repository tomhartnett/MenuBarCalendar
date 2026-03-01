//
//  DayView.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 2/28/26.
//

import SwiftUI

struct DayView: View {
    let day: MonthViewModel.Day

    var textColor: Color {
        if day.isToday {
            return Color(nsColor: .white)
        } else if day.isInMonth {
            return Color.primary
        } else {
            return Color.secondary
        }
    }

    var body: some View {
        ZStack {
            if day.isToday {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Color.accentColor.opacity(0.75))
            }

            Text("\(day.dayOfMonth)")
                .frame(maxWidth: .infinity)
                .foregroundStyle(textColor)
                .italic(!day.isInMonth)
                .fontWeight(day.isInMonth ? .medium : .regular)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .contentShape(Rectangle())
        .help(day.helpText)
    }
}

#Preview {
    HStack {
        DayView(day: .init(Date(), isInMonth: true, isToday: true, helpText: "Today"))
        DayView(day: .init(Date(), isInMonth: true, isToday: false, helpText: "Today"))
        DayView(day: .init(Date(), isInMonth: false, isToday: false, helpText: "Today"))
    }
}
