import XCTest
@testable import HolidayFinder

class AirportSelectionViewModelTests: XCTestCase {
    var viewModel: AirportSelectionViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = AirportSelectionViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchAirports() {
        // Given
        let airport1 = Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX")
        let airport2 = Airport(id: UUID(), icao: "JFK", iata: "JFK", name: "John F. Kennedy International Airport", city: "New York", state: "New York", country: "United States", elevation: 13, lat: 40.639751, lon: -73.778925, tz: "America/New_York", iataCode: "JFK")
        mockNetworkService.mockAirports = [airport1, airport2]
        
        let expectation = XCTestExpectation(description: "Fetch airports")
        
        // When
        viewModel.fetchAirports()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAirportsCalled)
            XCTAssertEqual(self.viewModel.airports.count, 2)
            XCTAssertEqual(self.viewModel.airports[0].iata, "LAX")
            XCTAssertEqual(self.viewModel.airports[1].iata, "JFK")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchAirports() {
        // Given
        viewModel.airports = [
            Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX"),
            Airport(id: UUID(), icao: "JFK", iata: "JFK", name: "John F. Kennedy International Airport", city: "New York", state: "New York", country: "United States", elevation: 13, lat: 40.639751, lon: -73.778925, tz: "America/New_York", iataCode: "JFK")
        ]
        
        // When
        viewModel.searchAirports(with: "Los")
        
        // Then
        XCTAssertEqual(viewModel.filteredAirports.count, 1)
        XCTAssertEqual(viewModel.filteredAirports[0].iata, "LAX")
    }
    func testSaveSelectedAirport() {
        // Given
        let airport = Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX")
        
        // When
        viewModel.saveSelectedAirport(selectedAirport: airport)
        
        // Then
        let savedAirportData = UserDefaults.standard.value(forKey: "selectedAirport") as? Data
        XCTAssertNotNil(savedAirportData)
        
        let savedAirport = try? JSONDecoder().decode(Airport.self, from: savedAirportData!)
        XCTAssertEqual(savedAirport, airport)
    }
    func testLoadSelectedAirport() {
        // Given
        let airport = Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX")
        let airportData = try? JSONEncoder().encode(airport)
        UserDefaults.standard.set(airportData, forKey: "selectedAirport")
        
        // When
        viewModel.loadSelectedAirport()
        
        // Then
        XCTAssertEqual(viewModel.selectedAirport, airport)
    }
    func testIsAirportSelected_True() {
        // Given
        let airport = Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX")
        let airportData = try? JSONEncoder().encode(airport)
        UserDefaults.standard.set(airportData, forKey: "selectedAirport")
        
        // When
        let isSelected = viewModel.isAirportSelected()
        
        // Then
        XCTAssertTrue(isSelected)
    }

    func testIsAirportSelected_False() {
        // Given
        UserDefaults.standard.removeObject(forKey: "selectedAirport")
        
        // When
        let isSelected = viewModel.isAirportSelected()
        
        // Then
        XCTAssertFalse(isSelected)
    }
    func testClearUserDefaults() {
        // Given
        let airport = Airport(id: UUID(), icao: "LAX", iata: "LAX", name: "Los Angeles International Airport", city: "Los Angeles", state: "California", country: "United States", elevation: 125, lat: 33.9425, lon: -118.408056, tz: "America/Los_Angeles", iataCode: "LAX")
        let airportData = try? JSONEncoder().encode(airport)
        UserDefaults.standard.set(airportData, forKey: "selectedAirport")
        
        // When
        viewModel.clearUserDefaults()
        
        // Then
        XCTAssertNil(UserDefaults.standard.value(forKey: "selectedAirport") as? Data)
        XCTAssertNil(viewModel.selectedAirport)
    }
}
