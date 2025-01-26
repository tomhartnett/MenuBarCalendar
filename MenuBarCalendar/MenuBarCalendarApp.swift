//
//  MenuBarCalendarApp.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

@main
struct MenuBarCalendarApp: App {
    @StateObject var context = AppContext()

    @StateObject var monthViewModel = MonthViewModel()

    @State private var observer: NSKeyValueObservation?

    // Workaround for SwiftUI preview support.
    private var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
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
            .onAppear {
                // TODO: revisit below workarounds as new versions of Xcode are released.

                // Workaround for `@Environment(\.scenePhase)` not working with `MenuBarExtra`.
                observer = NSApplication.shared.observe(\.keyWindow) { _, _ in
                    if NSApplication.shared.keyWindow != nil {
                        context.today()
                    }
                }

                // Workaround for issue where MonthCalendarView does not render on first appearance of view.
                // Started when compiled with Xcode 16.0.
                monthViewModel.changeMonth(0)
                context.today()
            }

        }, label: {
            Image(.customCalendarBadgeArrowDown)
        })
        .menuBarExtraStyle(.window)
    }
}
