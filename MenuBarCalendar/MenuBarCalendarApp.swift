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

    var body: some Scene {
        MenuBarExtra(content: {
            VStack(alignment: .leading) {
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
            .padding([.horizontal, .bottom])
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
