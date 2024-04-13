// AddHolidayModalViewModelTests.swift

import XCTest
@testable import HolidayFinder

class AddHolidayModalViewModelTests: XCTestCase {
    var viewModel: AddHolidayModalViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = AddHolidayModalViewModel(defaultOriginAirport: nil, initialStartDate: nil)
        viewModel.networkService = mockNetworkService
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchAirports_Success() {
        // Given
        let mockAirports = [
            Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX"),
            Airport(id: UUID(), icao: "JFK", iata: "JFK", name: "John F. Kennedy International Airport", city: "New York", state: "New York", country: "United States", elevation: 13, lat: 40.639751, lon: -73.778925, tz: "America/New_York", iataCode: "JFK")
        ]
        mockNetworkService.mockAirports = mockAirports
        let expectation = XCTestExpectation(description: "Fetch airports")
        // When
        viewModel.fetchAirports()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAirportsCalled)
            XCTAssertEqual(self.viewModel.airports, mockAirports)
            XCTAssertEqual(self.viewModel.filteredAirports, mockAirports)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchAirports() {
        // Given
        let mockAirports = [
            Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX"),
            Airport(id: UUID(), icao: "JFK", iata: "JFK", name: "John F. Kennedy International Airport", city: "New York", state: "New York", country: "United States", elevation: 13, lat: 40.639751, lon: -73.778925, tz: "America/New_York", iataCode: "JFK")
        ]
        viewModel.airports = mockAirports
        
        // When
        viewModel.searchAirports(query: "Los")
        
        // Then
        XCTAssertEqual(viewModel.filteredAirports.count, 1)
        XCTAssertEqual(viewModel.filteredAirports[0].iata, "LAX")
    }
    
    func testSelectOriginAirport() {
        // Given
        let airport = Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX")
        
        // When
        viewModel.selectOriginAirport(airport)
        
        // Then
        XCTAssertEqual(viewModel.originAirport, airport.iata)
        XCTAssertFalse(viewModel.showAirportSelection)
    }
    
    func testSelectDestinationAirport() {
        // Given
        let airport = Airport(id: UUID(), icao: "JFK", iata: "JFK", name: "John F. Kennedy International Airport", city: "New York", state: "New York", country: "United States", elevation: 13, lat: 40.639751, lon: -73.778925, tz: "America/New_York", iataCode: "JFK")
        
        // When
        viewModel.selectDestinationAirport(airport)
        
        // Then
        XCTAssertEqual(viewModel.destinationAirport, airport.iata)
        XCTAssertFalse(viewModel.showAirportSelection)
    }
    
    func testSaveVacation() {
        // Given
        viewModel.originAirport = "LAX"
        viewModel.destinationAirport = "JFK"
        viewModel.startDate = Date()
        viewModel.endDate = Date().addingTimeInterval(3600 * 24 * 7)
        
        // Clear UserDefaults before running the test
        UserDefaults.standard.removeObject(forKey: "vacationList")
        
        // When
        viewModel.saveVacation()
        
        // Then
        let savedVacations = UserDefaults.standard.object(forKey: "vacationList") as? Data
        XCTAssertNotNil(savedVacations)
        
        let decoder = JSONDecoder()
        let vacationList = try? decoder.decode([VacationDetails].self, from: savedVacations!)
        XCTAssertNotNil(vacationList)
        XCTAssertEqual(vacationList?.count, 1)
        XCTAssertEqual(vacationList?[0].originAirport, "LAX")
        XCTAssertEqual(vacationList?[0].destinationAirport, "JFK")
    }
}
