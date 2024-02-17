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
    @StateObject var viewModel = AirportSelectionViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }
    }
}
