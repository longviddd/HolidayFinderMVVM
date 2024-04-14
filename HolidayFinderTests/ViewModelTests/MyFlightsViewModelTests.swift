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
        let savedFlight = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        let savedFlightsData = try? JSONEncoder().encode([savedFlight])
        UserDefaults.standard.set(savedFlightsData, forKey: "myFlights")
        
        viewModel.loadSavedFlights()
        
        XCTAssertFalse(viewModel.savedFlights.isEmpty)
        XCTAssertEqual(viewModel.savedFlights.count, 1)
        XCTAssertEqual(viewModel.savedFlights[0].data.type, savedFlight.data.type)
    }
    
    func testDeleteFlight() {
        // Given
        let savedFlight1 = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        let savedFlight2 = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        viewModel.savedFlights = [savedFlight1, savedFlight2]
        
        viewModel.deleteFlight(at: 0)
        
        XCTAssertEqual(viewModel.savedFlights.count, 1)
        XCTAssertEqual(viewModel.savedFlights[0].data.type, savedFlight2.data.type)
    }
    
    func testFormatDate() {
        let dateString = "2024-03-16T10:30:00"
        let expectedFormattedDate = "Mar 16, 2024"
        
        let formattedDate = viewModel.formatDate(dateString)
        
        XCTAssertEqual(formattedDate, expectedFormattedDate)
    }
}
