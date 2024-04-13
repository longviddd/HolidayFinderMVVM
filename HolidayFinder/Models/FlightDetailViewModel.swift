//
//  FlightDetailViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-12.
//

import Foundation
class FlightDetailViewModel: ObservableObject {
    @Published var flightDetails: FlightResponsePrice?
    @Published var isLoading = false
    @Published var routeTitle = ""
    @Published var totalPrice = ""
    @Published var validatingCarrier = ""
    @Published var showingAlert = false
    @Published var alertMessage = ""
    
    private let selectedFlightOffer: FlightOffer
    private let networkService: NetworkService
    
    init(selectedFlightOffer: FlightOffer, networkService: NetworkService = NetworkService.shared) {
        self.selectedFlightOffer = selectedFlightOffer
        self.networkService = networkService
        fetchFlightDetails()
    }
    
    func fetchFlightDetails() {
        isLoading = true
        
        networkService.fetchAuthToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                self.networkService.fetchFlightDetails(selectedFlightOffer: self.selectedFlightOffer, token: token) { result in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        
                        switch result {
                        case .success(let flightResponse):
                            self.flightDetails = flightResponse
                            self.extractFlightInformation()
                            print(flightResponse)
                        case .failure(let error):
                            print("Error fetching flight details: \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching auth token: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    internal func extractFlightInformation() {
        guard let flightDetails = flightDetails else { return }
        
        guard let firstOffer = flightDetails.data.flightOffers.first,
              let firstItinerary = firstOffer.itineraries.first,
              let lastItinerary = firstOffer.itineraries.last else {
            // Handle the case when flightOffers or itineraries is empty
            routeTitle = "No flight information available"
            totalPrice = "N/A"
            validatingCarrier = "N/A"
            return
        }
        
        let originLocation = firstItinerary.segments.first?.departure.iataCode ?? "N/A"
        let destination = lastItinerary.segments.last?.arrival.iataCode ?? "N/A"
        routeTitle = "Flight from \(originLocation) - \(destination)"
        
        let price = firstOffer.price.total
        totalPrice = price
        
        let carrierCode = firstOffer.validatingAirlineCodes.first ?? "N/A"
        validatingCarrier = carrierCode
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formatTime(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: timeString) else {
            return ""
        }
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func formatDuration(_ duration: String) -> String {
        return duration.replacingOccurrences(of: "PT", with: "")
    }
    func saveFlightToMyList() {
        guard let flightDetails = flightDetails else { return }
        
        let encoder = JSONEncoder()
        if let encodedFlightDetails = try? encoder.encode(flightDetails) {
            if var savedFlightsData = UserDefaults.standard.data(forKey: "myFlights") {
                var savedFlights = try? JSONDecoder().decode([FlightResponsePrice].self, from: savedFlightsData)
                savedFlights?.append(flightDetails)
                if let updatedFlightsData = try? encoder.encode(savedFlights) {
                    UserDefaults.standard.set(updatedFlightsData, forKey: "myFlights")
                    alertMessage = "Flight saved successfully"
                } else {
                    alertMessage = "Failed to save flight. Please try again later."
                }
            } else {
                let firstFlightList = [flightDetails]
                if let firstFlightData = try? encoder.encode(firstFlightList) {
                    UserDefaults.standard.set(firstFlightData, forKey: "myFlights")
                    alertMessage = "Flight saved successfully"
                } else {
                    alertMessage = "Failed to save flight. Please try again later."
                }
            }
        } else {
            alertMessage = "Failed to save flight. Please try again later."
        }
        
        showingAlert = true
    }
}
