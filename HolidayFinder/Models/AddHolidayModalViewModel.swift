//
//  AddHolidayModalViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-04.
//

import Foundation
import Combine

class AddHolidayModalViewModel: ObservableObject {
    @Published var originAirport: String = ""
    @Published var destinationAirport: String = ""
    @Published var startDate = Date()
    @Published var endDate = Date()
    @Published var currentStep = 1
    @Published var isLoading = false
    @Published var showAirportSelection: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var airports: [Airport] = []
    @Published var filteredAirports: [Airport] = []
    @Published var searchQuery: String = ""
    private var searchCancellable: AnyCancellable?
    var networkService: NetworkService
    init(defaultOriginAirport: String? = nil, initialStartDate: Date? = nil, networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
        fetchAirports()
        setupSearch()
        loadDefaults(defaultOriginAirport: defaultOriginAirport, initialStartDate: initialStartDate)
        
    }
    private func loadDefaults(defaultOriginAirport: String?, initialStartDate: Date?) {
        if let defaultOriginAirport = defaultOriginAirport, !defaultOriginAirport.isEmpty {
            self.originAirport = defaultOriginAirport
        }
        self.startDate = initialStartDate ?? Date()

        // Set the end date to one day after the start date
        if let initialStartDate = initialStartDate {
            self.endDate = Calendar.current.date(byAdding: .day, value: 1, to: initialStartDate) ?? Date()
        } else {
            self.endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        }
    }
    func setupSearch() {
         searchCancellable = $searchQuery
             .removeDuplicates()
             .debounce(for: .seconds(3), scheduler: DispatchQueue.main)
             .sink(receiveValue: searchAirports)
     }

    func fetchAirports() {
        isLoading = true
        networkService.fetchAirports { [weak self] fetchedAirports in
            DispatchQueue.main.async {
                self?.isLoading = false
                guard let airports = fetchedAirports else { return }
                self?.airports = airports
                self?.filteredAirports = airports
            }
        }
    }
    func searchAirports(query: String) {
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
    func selectOriginAirport(_ airport: Airport) {
        originAirport = airport.iata
        showAirportSelection = false
        print(airport.iata)
    }
    
    func selectDestinationAirport(_ airport: Airport) {
        destinationAirport = airport.iata
        showAirportSelection = false
    }
    func showAirportListForSelection(isOrigin: Bool) {
        // Reset search query when showing list
        searchQuery = ""
        searchAirports(query: searchQuery)
        showAirportSelection = true
    }
    func saveVacation() {
        let vacationDetails = VacationDetails(originAirport: originAirport, destinationAirport: destinationAirport, startDate: startDate, endDate: endDate)
        print(vacationDetails)
        
        let encoder = JSONEncoder()
        if let encodedVacationDetails = try? encoder.encode(vacationDetails) {
            if var existingVacationsData = UserDefaults.standard.object(forKey: "vacationList") as? Data {
                var existingVacations = try? JSONDecoder().decode([VacationDetails].self, from: existingVacationsData)
                existingVacations?.append(vacationDetails)
                if let updatedVacationsData = try? encoder.encode(existingVacations) {
                    UserDefaults.standard.set(updatedVacationsData, forKey: "vacationList")
                }
            } else {
                // First vacation being saved
                let firstVacationList = [vacationDetails]
                if let firstVacationData = try? encoder.encode(firstVacationList) {
                    UserDefaults.standard.set(firstVacationData, forKey: "vacationList")
                }
            }
        }
    }
    
    func nextStep() {
        if currentStep < 4 {
            currentStep += 1
        }
    }
    
    func previousStep() {
        if currentStep > 1 {
            currentStep -= 1
        }
    }
    var isNextButtonEnabled: Bool {
        switch currentStep {
        case 1:
            return !originAirport.isEmpty
        case 2:
            return !destinationAirport.isEmpty && originAirport != destinationAirport
        case 4:
            return endDate > startDate
        default:
            return true
        }
    }
    func printVacations() {
        if let savedVacationsData = UserDefaults.standard.object(forKey: "vacationList") as? Data {
            if let savedVacations = try? JSONDecoder().decode([VacationDetails].self, from: savedVacationsData) {
                for vacation in savedVacations {
                    print("Origin: \(vacation.originAirport), Destination: \(vacation.destinationAirport), Start Date: \(vacation.startDate), End Date: \(vacation.endDate)")
                }
            } else {
                print("Failed to decode vacation list from UserDefaults.")
            }
        } else {
            print("No vacation list found in UserDefaults.")
        }
    }
}
