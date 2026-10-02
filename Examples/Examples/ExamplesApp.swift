//
//  ExamplesApp.swift
//  Examples
//
//  Created by Szymon on 30/6/2023.
//

import SwiftUI

@main
struct ExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(initialDemo: requestedDemo)
        }
    }

    private var requestedDemo: ContentView.Demo? {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: "--demo"), index + 1 < arguments.count else { return nil }
        return ContentView.Demo(rawValue: arguments[index + 1])
    }
}
