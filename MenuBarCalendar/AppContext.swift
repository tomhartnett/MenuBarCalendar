//
//  AppContext.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/29/23.
//

import Foundation

class AppContext: ObservableObject {
    @Published private(set) var selectedDate: Date?
    @Published private(set) var todayDisplayText = ""

    private var todayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()

    func today() {
        let now = Date()
        selectedDate = now
        todayDisplayText = todayFormatter.string(from: now)
    }
}
