//
//  TodayView.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/29/23.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var context: AppContext

    var body: some View {
        HStack(spacing: 16) {
            Button("Today", action: {
                context.today()
            })

            Text(context.todayDisplayText)
                .italic()
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
