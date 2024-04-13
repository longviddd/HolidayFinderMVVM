//
//  HolidayDetailView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-03.
//

import SwiftUI

struct HolidayDetailView: View {
    
    @StateObject var viewModel: HolidayDetailViewModel
    @State private var showingAddHolidayModal = false
    var defaultOriginAirport: String = ""
    init(holiday: Holiday) {
        _viewModel = StateObject(wrappedValue: HolidayDetailViewModel(holiday: holiday))
        if let data = UserDefaults.standard.object(forKey: "selectedAirport") as? Data,
           let category = try? JSONDecoder().decode(Airport.self, from: data) {
            defaultOriginAirport = category.iata
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(viewModel.holiday.name)
                    .font(.largeTitle)
                    .accessibilityIdentifier("HolidayName")
                
                Text("\(viewModel.holiday.date) (\(viewModel.getDayOfWeek(date: viewModel.holiday.date) ?? "N/A"))")
                    .font(.title2)
                    .accessibilityIdentifier("HolidayDate")
                
                Text(viewModel.holiday.types[0])
                    .font(.title3)
                    .accessibilityIdentifier("HolidayType")
                Button("Add to My Vacation List") {
                    showingAddHolidayModal = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Holiday Details")
        .sheet(isPresented: $showingAddHolidayModal) {
            AddHolidayModalView(defaultOriginAirport: defaultOriginAirport, initialStartDate: viewModel.holiday.date.toDate())
        }
    }
}
struct HolidayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock Holiday object
        let mockHoliday = Holiday( date: "2024-12-25", localName: "Christmas Day", name: "Christmas Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public", "Bank"])

        HolidayDetailView(holiday: mockHoliday)
    }
}
