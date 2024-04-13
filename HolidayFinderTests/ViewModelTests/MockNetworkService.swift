//
//  MockNetworkService.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-03.
//

import Foundation
@testable import HolidayFinder

class MockNetworkService: NetworkService {
    var fetchAuthTokenCalled = false
    var fetchFlightDetailsCalled = false
    var flightResponsePrice: FlightResponsePrice?
    var fetchFlightDetailsError: Error?
    var fetchFlightsCalled = false
    var flightResponse: FlightResponse?
    var fetchFlightsError: Error?
    var fetchAirportsCalled = false
    var fetchHolidaysCalled = false
    var fetchHolidaysHandler: ((_ countryCode: String, _ year: String, _ completion: @escaping ([Holiday]?) -> Void) -> Void)?
    var fetchAvailableCountriesCalled = false
    var availableCountries: [Country]?
    var fetchAvailableCountriesError: Error?
    var mockAirports: [Airport]?
    override init() {
        super.init()
    }
    override func fetchHolidays(forCountry countryCode: String, year: String, completion: @escaping ([Holiday]?) -> Void) {
        fetchHolidaysCalled = true
        fetchHolidaysHandler?(countryCode, year, completion)
    }
    override func fetchAvailableCountries(completion: @escaping ([Country]?) -> Void) {
        fetchAvailableCountriesCalled = true
        if let error = fetchAvailableCountriesError {
            completion(nil)
        } else {
            completion(availableCountries)
        }
    }
    override func fetchAuthToken(completion: @escaping (Result<String, Error>) -> Void) {
        fetchAuthTokenCalled = true
        completion(.success("mock_token"))
    }
    
    override func fetchFlightDetails(selectedFlightOffer: FlightOffer, token: String, completion: @escaping (Result<FlightResponsePrice?, Error>) -> Void) {
        fetchFlightDetailsCalled = true
        if let error = fetchFlightDetailsError {
            completion(.failure(error))
        } else {
            completion(.success(flightResponsePrice))
        }
    }
    override func fetchFlights(originAirport: String, destinationAirport: String, departureDate: String, returnDate: String, adults: Int, authToken: String, completion: @escaping (Result<FlightResponse?, Error>) -> Void) {
        print("Run")
        fetchFlightsCalled = true
        if let error = fetchFlightsError {
            completion(.failure(error))
        } else {
            completion(.success(flightResponse))
        }
    }
    override func fetchAirports(completion: @escaping ([Airport]?) -> Void) {
        fetchAirportsCalled = true
        completion(mockAirports)
    }
}
