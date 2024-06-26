//
//  AirportSelectionViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-02-10.
//

import Foundation
import Combine

class AirportSelectionViewModel: ObservableObject {
    @Published var airports: [Airport] = []
    @Published var filteredAirports: [Airport] = []
    @Published var selectedAirport: Airport?
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService.shared) {
         self.networkService = networkService
         fetchAirports()
     }
    func fetchAirports() {
        self.isLoading = true
        networkService.fetchAirports { [weak self] fetchedAirports in
            DispatchQueue.main.async {
                self?.isLoading = false // Stop loading
                guard let airports = fetchedAirports else { return }
                self?.airports = airports
                self?.filteredAirports = airports
            }
        }
    }

    func saveSelectedAirport(selectedAirport: Airport?) {
        if let encoded = try? JSONEncoder().encode(selectedAirport) {
            UserDefaults.standard.set(encoded, forKey: "selectedAirport")
        }


    }

    func loadSelectedAirport() {
        if let data = UserDefaults.standard.value(forKey:"selectedAirport") as? Data {
            selectedAirport = try? JSONDecoder().decode(Airport.self, from: data)
        }
    }
    
    func searchAirports(with query: String) {
        if query.isEmpty {
            filteredAirports = airports
        } else {
            filteredAirports = airports.filter { airport in
                airport.name.localizedCaseInsensitiveContains(query) ||
                airport.city.localizedCaseInsensitiveContains(query) ||
                airport.country.localizedCaseInsensitiveContains(query) ||
                airport.iata.localizedCaseInsensitiveContains(query)
            }
        }
    }
    
    func isAirportSelected() -> Bool {
        return UserDefaults.standard.value(forKey: "selectedAirport") as? Data != nil
    }
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "selectedAirport")
        selectedAirport = nil
    }
}

