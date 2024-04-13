
//
//  FlightDetailViewModelTests.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-03.
//

import XCTest
@testable import HolidayFinder

class FlightDetailViewModelTests: XCTestCase {
    var viewModel: FlightDetailViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        let selectedFlightOffer = FlightOffer(type: "flight-offer", id: "1", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: nil, lastTicketingDate: "2024-04-03", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "EUR", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true), validatingAirlineCodes: ["EK"], travelerPricings: [])
        viewModel = FlightDetailViewModel(selectedFlightOffer: selectedFlightOffer, networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchFlightDetails_Success() {
        // Given
        let expectedFlightResponse = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offers-pricing", flightOffers: []), dictionaries: nil)
        mockNetworkService.flightResponsePrice = expectedFlightResponse
        
        let expectation = XCTestExpectation(description: "Fetch flight details")
        
        // When
        viewModel.fetchFlightDetails()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAuthTokenCalled)
            XCTAssertTrue(self.mockNetworkService.fetchFlightDetailsCalled)
            XCTAssertEqual(self.viewModel.flightDetails, expectedFlightResponse)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchFlightDetails_Failure() {
        // Given
        mockNetworkService.fetchFlightDetailsError = NSError(domain: "TestError", code: 0, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Fetch flight details failure")
        
        // When
        viewModel.fetchFlightDetails()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAuthTokenCalled)
            XCTAssertTrue(self.mockNetworkService.fetchFlightDetailsCalled)
            XCTAssertNil(self.viewModel.flightDetails)
            XCTAssertFalse(self.viewModel.isLoading)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFormatDate() {
        // Given
        let dateString = "2024-03-16T10:30:00"
        let expectedFormattedDate = "Mar 16, 2024"
        
        // When
        let formattedDate = viewModel.formatDate(dateString)
        
        // Then
        XCTAssertEqual(formattedDate, expectedFormattedDate)
    }
    
    func testFormatTime() {
        // Given
        let timeString = "2024-03-16T10:30:00"
        let expectedFormattedTime = "10:30"
        
        // When
        let formattedTime = viewModel.formatTime(timeString)
        
        // Then
        XCTAssertEqual(formattedTime, expectedFormattedTime)
    }
    
    func testFormatDuration() {
        // Given
        let duration = "PT6H30M"
        let expectedFormattedDuration = "6H30M"
        
        // When
        let formattedDuration = viewModel.formatDuration(duration)
        
        // Then
        XCTAssertEqual(formattedDuration, expectedFormattedDuration)
    }
    
    func testSaveFlightToMyList() {
        // Given
        let flightDetails = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offers-pricing", flightOffers: []), dictionaries: nil)
        viewModel.flightDetails = flightDetails
        
        // Clear UserDefaults before running the test
        UserDefaults.standard.removeObject(forKey: "myFlights")
        
        // When
        viewModel.saveFlightToMyList()
        
        // Then
        XCTAssertTrue(viewModel.showingAlert)
        XCTAssertEqual(viewModel.alertMessage, "Flight saved successfully")
        
        let savedFlights = UserDefaults.standard.object(forKey: "myFlights") as? Data
        XCTAssertNotNil(savedFlights)
        
        let decodedFlights = try? JSONDecoder().decode([FlightResponsePrice].self, from: savedFlights!)
        XCTAssertNotNil(decodedFlights)
        XCTAssertEqual(decodedFlights?.count, 1)
        XCTAssertEqual(decodedFlights?[0].data.type, flightDetails.data.type)
    }
}
