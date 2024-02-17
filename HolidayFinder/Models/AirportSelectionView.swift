//
//  AirportSelectionView.swift
//  HolidayFinder
//
//  Created by long on 2024-02-10.
//

import SwiftUI

struct AirportSelectionView: View {
    @ObservedObject var viewModel: AirportSelectionViewModel
    @State private var searchQuery = ""
    @State private var showMainView = false
    @State private var showingTooltip = false // Initialize as false to not show the tooltip initially
    @State private var selectedAirportId: UUID?

    var body: some View {
        NavigationView {
            List(viewModel.filteredAirports) { airport in
                ZStack {
                    // Background for highlighting
                    Rectangle()
                        .foregroundColor(selectedAirportId == airport.id ? .gray.opacity(0.5) : .clear)
                        .cornerRadius(5)
                        .animation(.easeIn, value: selectedAirportId)
                    
                    HStack {
                        Text("\(airport.city), \(airport.country) - \(airport.name)")
                            .padding()
                        Spacer() // Pushes the text to the left
                    }
                    
                }
                .onTapGesture {
                    viewModel.saveSelectedAirport(selectedAirport: airport)
                    self.showMainView = true
                }
                .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                    self.selectedAirportId = isPressing ? airport.id : nil
                }) {
                    // Actions to perform after the long press gesture is recognized
                }
                // Ensures the list row takes up the full width
                .listRowInsets(EdgeInsets())
            }
            .searchable(text: $searchQuery)
            .onChange(of: searchQuery) { newValue in
                viewModel.searchAirports(with: newValue)
            }
            .fullScreenCover(isPresented: $showMainView) {
                MainView(viewModel: viewModel)
            }
            .navigationTitle("Choose Your Preferred Airport")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingTooltip.toggle() // This toggles the tooltip visibility
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .foregroundColor(.gray)
                    .sheet(isPresented: $showingTooltip) {
                        // Tooltip view content
                        VStack {
                            Text("Tooltip")
                                .font(.title)
                                .padding()
                            Text("If flying internationally, search 'international' in the box.")
                                .padding()
                            Button("Close") {
                                showingTooltip = false // Explicitly set to false when the button is tapped
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AirportSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        AirportSelectionView(viewModel: AirportSelectionViewModel())
    }
}
