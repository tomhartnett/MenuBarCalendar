//
//  AppContext.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/29/23.
//

import Foundation

class AppContext: ObservableObject {
    @Published private(set) var selectedDate: Date

    init(date: Date) {
        selectedDate = date
    }

    func today() {
        selectedDate = Calendar.autoupdatingCurrent.startOfDay(for: Date())
    }
}
