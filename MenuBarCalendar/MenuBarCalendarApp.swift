//
//  MenuBarCalendarApp.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/22/23.
//

import SwiftUI

@main
struct MenuBarCalendarApp: App {
    var body: some Scene {
        MenuBarExtra(content: {
            MonthCalendar()

            Divider()

            HStack {
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .padding([.leading, .bottom])

                Spacer()
            }

        }, label: {
            Image(systemName: "calendar.badge.clock")
        })
        .menuBarExtraStyle(.window)
    }
}
