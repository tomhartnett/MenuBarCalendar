//
//  TodayView.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 4/29/23.
//

import SwiftUI

struct TodayView: View {
    @EnvironmentObject var context: AppContext

    @State private var isMouseOver: Bool = false

    var body: some View {
        HStack(spacing: 16) {
            Text(context.selectedDate, format: Date.FormatStyle(date: .complete, time: .omitted).attributedStyle)
                .foregroundStyle(isMouseOver ? Color.white : Color.primary)
                .padding(.leading, 8)

            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 22)
        .background(isMouseOver ? Color.accentColor.opacity(0.75) : Color.clear)
        .cornerRadius(4)
        .onHover { isOver in
            isMouseOver = isOver
        }
        .onTapGesture {
            context.today()
            isMouseOver = false
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
