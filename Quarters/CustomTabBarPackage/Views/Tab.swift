//
//  Tab.swift
//  Quarters
//
//  Created by J. DeWeese on 1/8/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case recents = "Recents"
    case search = "Filter"
    case charts = "Charts"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .recents:
            return "calendar"
        case .search:
            return "magnifyingglass"
        case .charts:
            return "chart.bar.xaxis"
        case .settings:
            return "gearshape"
            
        }
    }
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
