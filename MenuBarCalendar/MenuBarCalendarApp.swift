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

                Divider()

                TodayView()
                    .environmentObject(context)

                Divider()

                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(.all, 8)
            .onAppear {
                // Workaround for `@Environment(\.scenePhase)` not working with `MenuBarExtra`.
                observer = NSApplication.shared.observe(\.keyWindow) { _, _ in
                    if NSApplication.shared.keyWindow != nil {
                        context.today()
                    }
                }
            }

        }, label: {
            Image(systemName: "calendar.badge.clock")
        })
        .menuBarExtraStyle(.window)
    }
}
