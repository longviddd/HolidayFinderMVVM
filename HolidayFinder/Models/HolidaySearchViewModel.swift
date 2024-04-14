//
//  HolidaySearchViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-02.
//

import Foundation
import Combine

class HolidaySearchViewModel: ObservableObject {
    @Published var testimonials = [
        "Finally, a travel app that gets me. Simple to use and always finds the best deals!",
        "Planning my holidays has never been easier. This app is a game-changer for travelers.",
        "Incredible app! Intuitive design and helpful features that made my vacation planning a breeze.",
        "Every feature you need to discover and book your perfect holiday is right here. Love it!",
        "I was impressed with how this app simplified the complex task of holiday planning. Highly recommend!",
        "A traveler's best friend! It's like having a personal travel agent in your pocket.",
        "The user experience is unmatched. Makes vacation search not just easy, but also fun.",
    ]
    @Published var shouldNavigate = false

    @Published var testimonialIndex = 0
    @Published var nearestAirport: Airport?
    @Published var vacationLocation: String = ""
    @Published var upcomingCurrentYearOnly = false
    @Published var yearSearch = String(Calendar.current.component(.year, from: Date()))
    @Published var vacationLocationsJson: [Country] = []
    @Published var isYearValid = true
    @Published var needsAirportSelection = false
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
        fetchVacationLocations()
        setupTestimonialRotation()
        UserDefaults.standard.removeObject(forKey: "selectedAirport")
    }



    func setupTestimonialRotation() {
        Timer.publish(every: 7, on: .main, in: .common).autoconnect().sink { [weak self] _ in
            guard let self = self else { return }
            self.testimonialIndex = (self.testimonialIndex + 1) % self.testimonials.count
        }.store(in: &cancellables)
    }
    func validateYearInput(text: String) {
        guard let yearValue = Int(text), yearValue >= Calendar.current.component(.year, from: Date()), yearValue <= 2073 else {
            isYearValid = false
            return
        }
        yearSearch = text
        isYearValid = true 
    }

    func fetchVacationLocations() {
        networkService.fetchAvailableCountries { [weak self] fetchedCountries in
            DispatchQueue.main.async {
                guard let countries = fetchedCountries else { return }
                self?.vacationLocationsJson = countries
            }
        }
    }



    func onBlurYearInput() {
        guard let yearValue = Int(yearSearch) else { return }
        if yearValue < Calendar.current.component(.year, from: Date()) {
            yearSearch = String(Calendar.current.component(.year, from: Date()))
            isYearValid = false
        } else if yearValue > 2073 {
            yearSearch = "2073"
            isYearValid = false
        } else {
            isYearValid = true
        }
    }

    func submitSearch() {
        guard isYearValid else { return }
        let searchParameters = ["selectedCountry": vacationLocation , "selectedYear": yearSearch, "upcomingCurrentYearOnly": upcomingCurrentYearOnly] as [String : Any]
        UserDefaults.standard.set(searchParameters, forKey: "searchParameters")
        print("Submitting search for location: \(vacationLocation )")
        shouldNavigate = true
    }

    func handleUpcomingCurrentYearOnlyChange(newValue: Bool) {
        upcomingCurrentYearOnly = newValue
        if newValue {
            let currentYearStr = String(Calendar.current.component(.year, from: Date()))
            yearSearch = currentYearStr
        }
    }
}
