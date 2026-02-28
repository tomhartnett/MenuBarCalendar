//
//  MenuBarCalendarApp.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

@main
struct MenuBarCalendarApp: App {
    @StateObject var context: AppContext

    @StateObject var monthViewModel: MonthViewModel

    init() {
        let today = Calendar.autoupdatingCurrent.startOfDay(for: Date())
        _context = StateObject(wrappedValue: AppContext(date: today))
        _monthViewModel = StateObject(wrappedValue: MonthViewModel(date: today))
    }

    var body: some Scene {
        MenuBarExtra(isInserted: .constant(!isPreview), content: {
            VStack(alignment: .leading, spacing: 8) {
                MonthCalendarView()
                    .environmentObject(context)
                    .environmentObject(monthViewModel)

                Divider()

                TodayView()
                    .environmentObject(context)

                Divider()

                QuitView()
            }
            .padding(.all, 8)
            .task {
                context.today()
            }
            .onDisappear {
                // Reduces "flicker" when showing calendar again after navigating away from current month.
                context.today()
            }

        }, label: {
            Image(.customCalendarBadgeArrowDown)
        })
        .menuBarExtraStyle(.window)
    }

    // Workaround for SwiftUI preview support.
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
