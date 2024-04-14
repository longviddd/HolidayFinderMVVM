//
//  FlightSearchViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation
import Combine

class FlightSearchViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading = false
    @Published var fetchError = false
    @Published var noFlightsFound = false
    internal var flightOffers: [FlightOffer] = []
    internal let vacation: VacationDetails
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkService
    
    init(vacation: VacationDetails, networkService: NetworkService = NetworkService.shared) {
        self.vacation = vacation
        self.networkService = networkService
    }
    func searchFlights() {
        isLoading = true
        fetchError = false
        noFlightsFound = false
        
        networkService.fetchAuthToken { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let token):
                self.fetchFlights(token: token)
            case .failure(let error):
                print("Error fetching auth token: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.fetchError = true
                }
            }
        }
    }
    
    internal func fetchFlights(token: String) {
        let departureDate = dateString(from: vacation.startDate)
        let returnDate = dateString(from: vacation.endDate)
        
        networkService.fetchFlights(
            originAirport: vacation.originAirport,
            destinationAirport: vacation.destinationAirport,
            departureDate: departureDate,
            returnDate: returnDate,
            adults: 1,
            authToken: token
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let flightResponse):
                    if let flightResponse = flightResponse {
                        self.flightOffers = flightResponse.data
                        if flightResponse.dictionaries == nil {
                            self.flights = []
                            self.noFlightsFound = true
                        }
                        else{
                            self.flights = flightResponse.data.map { flightOffer -> Flight in
                                let outboundSegments = flightOffer.itineraries[0].segments
                                let returnSegments = flightOffer.itineraries[1].segments
                                
                                let outboundOriginAirport = outboundSegments[0].departure
                                let outboundDestinationAirport = outboundSegments[outboundSegments.count - 1].arrival
                                let outboundDuration = flightOffer.itineraries[0].duration
                                
                                let returnOriginAirport = returnSegments[0].departure
                                let returnDestinationAirport = returnSegments[returnSegments.count - 1].arrival
                                let returnDuration = flightOffer.itineraries[1].duration
                                
                                return Flight(
                                    outboundOriginAirport: outboundOriginAirport.iataCode,
                                    outboundDestinationAirport: outboundDestinationAirport.iataCode,
                                    outboundDuration: self.formatDuration(outboundDuration!),
                                    returnOriginAirport: returnOriginAirport.iataCode,
                                    returnDestinationAirport: returnDestinationAirport.iataCode,
                                    returnDuration: self.formatDuration(returnDuration!),
                                    price: Double(flightOffer.price.total) ?? 0.0
                                )
                            }
                            
                        }
                    } else {
                        // No flights found
                        self.flights = []
                        self.noFlightsFound = true
                    }
                case .failure(let error):
                    print("Error fetching flights: \(error)")
                    self.fetchError = true
                }
            }
        }
    }
    
    internal func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: String) -> String {
        return duration.replacingOccurrences(of: "PT", with: "")
    }
    
    func sortByPrice() {
        flights.sort { $0.price < $1.price }
    }
    
    func sortByTotalDuration() {
        flights.sort { flight1, flight2 in
            let duration1 = durationToMinutes(flight1.outboundDuration) + durationToMinutes(flight1.returnDuration)
            let duration2 = durationToMinutes(flight2.outboundDuration) + durationToMinutes(flight2.returnDuration)
            return duration1 < duration2
        }
    }
    
    private func durationToMinutes(_ duration: String) -> Int {
        let components = duration.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let hours = Int(components.first ?? "") ?? 0
        let minutes = Int(components.last ?? "") ?? 0
        return hours * 60 + minutes
    }
    func findFlightOffer(for flight: Flight) -> FlightOffer? {
        return flightOffers.first { flightOffer in
            let outboundSegments = flightOffer.itineraries[0].segments
            let returnSegments = flightOffer.itineraries[1].segments
            
            let outboundOriginAirport = outboundSegments[0].departure.iataCode
            let outboundDestinationAirport = outboundSegments[outboundSegments.count - 1].arrival.iataCode
            let returnOriginAirport = returnSegments[0].departure.iataCode
            let returnDestinationAirport = returnSegments[returnSegments.count - 1].arrival.iataCode
            
            return flight.outboundOriginAirport == outboundOriginAirport &&
            flight.outboundDestinationAirport == outboundDestinationAirport &&
            flight.returnOriginAirport == returnOriginAirport &&
            flight.returnDestinationAirport == returnDestinationAirport &&
            flight.price == Double(flightOffer.price.total) ?? 0.0
        }
    }
    internal func convertFlightOffersToFlights(_ flightOffers: [FlightOffer]) -> [Flight] {
        return flightOffers.map { flightOffer -> Flight in
            let outboundSegments = flightOffer.itineraries[0].segments
            let returnSegments = flightOffer.itineraries[1].segments
            
            let outboundOriginAirport = outboundSegments[0].departure
            let outboundDestinationAirport = outboundSegments[outboundSegments.count - 1].arrival
            let outboundDuration = flightOffer.itineraries[0].duration
            
            let returnOriginAirport = returnSegments[0].departure
            let returnDestinationAirport = returnSegments[returnSegments.count - 1].arrival
            let returnDuration = flightOffer.itineraries[1].duration
            
            return Flight(
                outboundOriginAirport: outboundOriginAirport.iataCode,
                outboundDestinationAirport: outboundDestinationAirport.iataCode,
                outboundDuration: self.formatDuration(outboundDuration!),
                returnOriginAirport: returnOriginAirport.iataCode,
                returnDestinationAirport: returnDestinationAirport.iataCode,
                returnDuration: self.formatDuration(returnDuration!),
                price: Double(flightOffer.price.total) ?? 0.0
            )
        }
    }
}
