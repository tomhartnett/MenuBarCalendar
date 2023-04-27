//
//  MenuBarCalendarApp.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

class AppContext: ObservableObject {
    @Published var selectedDate: Date?
}

@main
struct MenuBarCalendarApp: App {
    @StateObject var appContext = AppContext()

    @State private var observer: NSKeyValueObservation?

    var body: some Scene {
        MenuBarExtra(content: {
            VStack(alignment: .leading) {
                MonthCalendar()
                    .environmentObject(appContext)

                Divider()

                Button("Today") {
                    appContext.selectedDate = Date()
                }

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
                        appContext.selectedDate = Date()
                    }
                }
            }

        }, label: {
            Image(systemName: "calendar.badge.clock")
        })
        .menuBarExtraStyle(.window)
    }
}
