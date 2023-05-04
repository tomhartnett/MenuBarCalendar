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
            Text(context.todayDisplayText)
                .italic()
                .onTapGesture {
                    #warning("tap gesture not working consistently")
                    context.today()
                }
        }
        .frame(idealHeight: 22)
        .background(Color.orange.opacity(0.5))
        .contentShape(Rectangle())
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
