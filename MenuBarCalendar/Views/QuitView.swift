//
//  QuitView.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 9/29/24.
//

import SwiftUI

struct QuitView: View {
    @State private var isMouseOver: Bool = false

    var body: some View {
        HStack {
            Text("Quit")
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
            NSApplication.shared.terminate(nil)
        }
    }
}
