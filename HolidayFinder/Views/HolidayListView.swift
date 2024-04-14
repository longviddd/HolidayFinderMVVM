//
//  HolidayListView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-02.
//

import SwiftUI


struct HolidayListView: View {
    @StateObject var viewModel = HolidayListViewModel()
    // State to manage the selected holiday for navigation
    @State private var selectedHoliday: Holiday?

    var body: some View {
            List(viewModel.holidays) { holiday in
                NavigationLink(destination: HolidayDetailView(holiday: holiday)) {
                    VStack(alignment: .leading) {
                        Text(holiday.date)
                            .font(.headline)
                        Text(holiday.name)
                            .font(.subheadline)
                        Text(holiday.types.joined(separator: ", "))
                            .font(.caption)
                    }
                }
                .accessibilityIdentifier("HolidayCell_\(holiday.id)")
            }
            .navigationTitle("Holidays")
            .task {
                viewModel.loadSearchParametersAndFetchHolidays()
            }
        }
    
}

