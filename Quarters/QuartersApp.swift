//
//  QuartersApp.swift
//  Quarters
//
//  Created by J. DeWeese on 1/8/24.
//

import SwiftUI
import WidgetKit

@main
struct Expense_TrackerApp: App {
    @Environment(\.scenePhase) private var scene
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scene, { oldValue, newValue in
                    if newValue == .background {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                })
        }
        .modelContainer(for: [Transaction.self])
    }
}
