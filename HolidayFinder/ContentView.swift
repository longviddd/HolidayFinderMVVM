//
//  ContentView.swift
//  HolidayFinder
//
//  Created by long on 2024-02-03.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: AirportSelectionViewModel

    var body: some View {
        NavigationView {
            if viewModel.isAirportSelected() {
                // Main view is shown directly without a back button to the selection view
                MainView(viewModel: viewModel)
            } else {
                // Airport selection view is shown initially
                AirportSelectionView(viewModel: viewModel)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper display on all devices
    }
}


struct MainView: View {
    var viewModel: AirportSelectionViewModel // Pass the ViewModel to MainView

    var body: some View {
        VStack {
            Text("Welcome to the Main Screen")
            // Add a button to clear UserDefaults
            Button(action: {
                viewModel.clearUserDefaults()
                print("UserDefaults cleared.")
            }) {
                Text("Clear UserDefaults")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // This should create an instance of ContentView for preview
        // Ensure to initialize the ViewModel as needed for the preview
        ContentView(viewModel: AirportSelectionViewModel())
    }
}


