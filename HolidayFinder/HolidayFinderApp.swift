//
//  HolidayFinderApp.swift
//  HolidayFinder
//
//  Created by long on 2024-02-03.
//

import SwiftUI

@main
struct HolidayFinderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
