//
//  TodayView.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/29/23.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var context: AppContext

    @State private var isHoverOver = false

    var body: some View {
        HStack(spacing: 16) {
            Button("Today", action: {
                context.today()
            })

            Text(context.todayDisplayText)
                .foregroundColor(.secondary)
                .fontWeight(isHoverOver ? .medium : .regular)
                .italic()
        }
        .contentShape(Rectangle())
        .onHover { over in
            isHoverOver = over
        }
        .onTapGesture {
            context.today()
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
