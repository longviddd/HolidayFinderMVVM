//
//  HolidayListViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-02.
//

import Foundation
import Combine

class HolidayListViewModel: ObservableObject {
    @Published var holidays: [Holiday] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedHoliday: Holiday?
    private let networkService: NetworkService
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchHolidays(forCountry countryCode: String, year: String, upcomingOnly: Bool) {
        networkService.fetchHolidays(forCountry: countryCode, year: year) { [weak self] fetchedHolidays in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let fetchedHolidays = fetchedHolidays {
                    self.holidays = fetchedHolidays.filter { holiday in
                        if upcomingOnly {
                            let dateFormatter = ISO8601DateFormatter()
                            dateFormatter.formatOptions = [.withFullDate, .withDashSeparatorInDate]
                            guard let holidayDate = dateFormatter.date(from: holiday.date) else { return false }
                            return holidayDate >= Date()
                        }
                        return true
                    }
                }
            }
        }
    }
    func loadSearchParametersAndFetchHolidays() {
        if let searchParameters = UserDefaults.standard.dictionary(forKey: "searchParameters") {
            guard let countryCode = searchParameters["selectedCountry"] as? String,
                  let year = searchParameters["selectedYear"] as? String else {
                return
            }
            
            let upcomingOnly = searchParameters["upcomingCurrentYearOnly"] as? Bool ?? false
            fetchHolidays(forCountry: countryCode, year: year, upcomingOnly: upcomingOnly)
        }
    }
}

