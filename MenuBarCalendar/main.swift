//
//  main.swift
//  MenuBarCalendar
//
//  Created by Tom Hartnett on 5/1/23.
//

import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
