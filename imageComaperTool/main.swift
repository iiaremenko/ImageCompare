//
//  main.swift
//  imageComaperTool
//
//  Created by iurii int on 07.10.2024.
//

import Foundation
import Cocoa
import SwiftUI

let arguments = CommandLine.arguments
var firstArgument = ""
var secondArgument = ""

if arguments.count == 3 {
    firstArgument = arguments[1]
    secondArgument = arguments[2]
    print("First argument: \(firstArgument)")
    print("Second argument: \(secondArgument)")
} else {
    print("Usage: imageCompare <imagePath1> <imagePath2>")
}

// Create the main entry point of your application
let app = NSApplication.shared
app.setActivationPolicy(.regular)

let delegate = AppDelegate()
app.delegate = delegate
app.run()

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let contentView = ContentView(
            viewModel: .init(path1: firstArgument, path2: secondArgument)
        )

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 600),
            styleMask: [.titled, .closable, .resizable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Image Compare Tool"
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)

        let menu = NSMenu(title: "Image Compare")
        menu.addItem(withTitle: "Quit ImageCompare",
                     action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        menu.addItem(withTitle: "Select All",
                     action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        menu.addItem(withTitle: "Copy",
                     action: #selector(NSText.copy(_:)), keyEquivalent: "c")

        app.mainMenu = menu

        // Activate the app and bring it to the front
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        .terminateNow
    }
}
