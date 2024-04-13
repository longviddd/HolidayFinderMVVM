//
//  MyFlightsViewModelTest.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-03.
//

import XCTest
@testable import HolidayFinder

class MyFlightsViewModelTests: XCTestCase {
    var viewModel: MyFlightsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MyFlightsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadSavedFlights() {
        // Given
        let savedFlight = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        let savedFlightsData = try? JSONEncoder().encode([savedFlight])
        UserDefaults.standard.set(savedFlightsData, forKey: "myFlights")
        
        // When
        viewModel.loadSavedFlights()
        
        // Then
        XCTAssertFalse(viewModel.savedFlights.isEmpty)
        XCTAssertEqual(viewModel.savedFlights.count, 1)
        XCTAssertEqual(viewModel.savedFlights[0].data.type, savedFlight.data.type)
    }
    
    func testDeleteFlight() {
        // Given
        let savedFlight1 = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        let savedFlight2 = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        viewModel.savedFlights = [savedFlight1, savedFlight2]
        
        // When
        viewModel.deleteFlight(at: 0)
        
        // Then
        XCTAssertEqual(viewModel.savedFlights.count, 1)
        XCTAssertEqual(viewModel.savedFlights[0].data.type, savedFlight2.data.type)
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
}
