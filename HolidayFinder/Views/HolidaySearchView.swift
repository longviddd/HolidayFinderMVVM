//
//  HolidaySearchView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-02.
//

import SwiftUI

struct HolidaySearchView: View {
    @StateObject var viewModel = HolidaySearchViewModel()
    @State private var showingAirportSelection = false

    var body: some View {
            VStack {
                Text("Holiday Vacation Search")
                    .font(.title)
                Text("Find the best holidays tailored for you")
                    .font(.subheadline)
             
                Picker("Select Vacation Location", selection: $viewModel.vacationLocation) {
                    if viewModel.vacationLocation.isEmpty {
                        Text("").tag(Optional<String>(nil))
                    }
                    ForEach(viewModel.vacationLocationsJson, id: \.countryCode) { country in
                        Text(country.name).tag(country.countryCode)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .accessibilityIdentifier("Select Vacation Location")
                Toggle(isOn: $viewModel.upcomingCurrentYearOnly) {
                    Text("Upcoming in Current Year Only")
                }
                .accessibilityIdentifier("Upcoming in Current Year Only")
                .padding()
                .onChange(of: viewModel.upcomingCurrentYearOnly) { newValue in
                    if newValue {

                        let currentYear = String(Calendar.current.component(.year, from: Date()))
                        viewModel.yearSearch = currentYear
                        viewModel.validateYearInput(text: currentYear) // Ensure the input is validated
                    }
                }

                TextField("Enter Year (current year to 2073)", text: $viewModel.yearSearch)
                    .keyboardType(.numberPad)
                    .padding()
                    .disabled(viewModel.upcomingCurrentYearOnly)
                    .accessibilityIdentifier("Enter Year (current year to 2073)")

                Button("Submit") {
                    viewModel.submitSearch()
                }
                .accessibilityIdentifier("Submit")
                .disabled(!viewModel.isYearValid)
                .padding()

                NavigationLink(destination: HolidayListView(), isActive: $viewModel.shouldNavigate) {
                    EmptyView()
                }
            }
            .onReceive(viewModel.$vacationLocationsJson) { countries in

                if let firstCountryCode = countries.first?.countryCode {
                    viewModel.vacationLocation = firstCountryCode
                }
            }
            .padding()
            .onChange(of: viewModel.yearSearch) { newValue in
                viewModel.validateYearInput(text: newValue)
            }
            .onAppear {
                showingAirportSelection = viewModel.needsAirportSelection
            }
            .sheet(isPresented: $showingAirportSelection) {

                AirportSelectionView(viewModel: AirportSelectionViewModel())
            }
        }
    
}

struct HolidaySearchView_Previews: PreviewProvider {
    static var previews: some View {
        HolidaySearchView()
    }
}
