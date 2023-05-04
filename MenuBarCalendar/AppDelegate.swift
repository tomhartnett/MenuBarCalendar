//
//  AppDelegate.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 5/1/23.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBar: NSStatusBar!
    private var statusItem: NSStatusItem!

    private var observer: NSKeyValueObservation?

    private let context = AppContext()

    private let windowWidth: CGFloat = 350

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = .system
        
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.image = NSImage (systemSymbolName: "calendar.badge.clock", accessibilityDescription: nil)

        statusItem.menu = buildMenu()

        #warning(".observe doesn't work here.")
        observer = NSApplication.shared.observe(\.keyWindow) { [weak self] _, _ in
            if NSApplication.shared.keyWindow != nil {
                self?.context.today()
            }
        }

        context.today()
    }

    func applicationWillBecomeActive(_ notification: Notification) {
        print("hello")
    }

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()

        let monthView = NSHostingView(rootView: MonthCalendarView().environmentObject(context))
        monthView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: windowWidth,
                                 height: monthView.intrinsicContentSize.height)

        let monthItem = NSMenuItem()
        monthItem.view = monthView
        menu.addItem(monthItem)

        let todayView = NSHostingView(rootView: TodayView().environmentObject(context))
        todayView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: windowWidth,
                                 height: todayView.intrinsicContentSize.height)

        let todayItem = NSMenuItem()
        todayItem.view = todayView
        menu.addItem(todayItem)

        menu.addItem(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit", action: #selector(quit(sender:)), keyEquivalent: "")
        menu.addItem(quitItem)

        return menu
    }

    @objc
    private func today(sender: AnyObject) {
        context.today()
    }

    @objc
    private func quit(sender: AnyObject) {
        NSApplication.shared.terminate(nil)
    }
}
