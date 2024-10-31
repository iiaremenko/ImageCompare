//
//  ImageCompareApp.swift
//  ImageCompare
//
//  Created by iurii int on 03.10.2024.
//

import SwiftUI
import AppKit

@main
struct ImageCompareApp: App {
    var firstArgument = ""
    var secondArgument = ""

    init() {
        let arguments = CommandLine.arguments
        if arguments.count > 2 {
            // Expand the tilde (~) in paths to absolute paths
            firstArgument = NSString(string: arguments[1]).expandingTildeInPath
            secondArgument = NSString(string: arguments[2]).expandingTildeInPath


            let firstURL = if firstArgument.contains("file://") {
                URL(string: firstArgument)!
            } else {
                URL(fileURLWithPath: firstArgument)
            }

            let secondURL = if secondArgument.contains("file://") {
                URL(string: secondArgument)!
            } else {
                URL(fileURLWithPath: secondArgument)
            }

            // Request permission to access the files
            requestPermissionForFile(firstURL)
            requestPermissionForFile(secondURL)
        } else {
            print("Please provide two file paths as arguments.")
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: .init(
                    path1: firstArgument,
                    path2: secondArgument
                )
            )
        }
    }

    func requestPermissionForFile(_ url: URL) {
        if url.startAccessingSecurityScopedResource() == false {
            // Use NSOpenPanel to request access to the file
            let openPanel = NSOpenPanel()
            openPanel.message = "Please grant access to the file \(url.lastPathComponent)"
            openPanel.prompt = "Allow"
            openPanel.allowsMultipleSelection = true
            openPanel.canChooseFiles = true
            openPanel.canChooseDirectories = true
            openPanel.directoryURL = url.deletingLastPathComponent()
            openPanel.allowedContentTypes = ImageComparisonViewModel.allowedContentTypes

            if openPanel.runModal() == .OK, let selectedURL = openPanel.url {
                do {
                    // Start accessing the security-scoped resource
                    if selectedURL.startAccessingSecurityScopedResource() {
                        defer {
                            selectedURL.stopAccessingSecurityScopedResource()
                        }
                        // Here, you can handle file reading or processing logic
                        let _ = try Data(contentsOf: selectedURL)
                        print("Successfully accessed file: \(selectedURL.path)")
                    } else {
                        print("Failed to access security-scoped resource for file: \(url.path)")
                    }
                } catch {
                    print("Error reading file: \(error)")
                }
            } else {
                print("User did not grant access to the file.")
            }
        }
    }
}
