import XCTest
@testable import HolidayFinder

class FlightSearchViewModelTests: XCTestCase {
    var viewModel: FlightSearchViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        let vacation = VacationDetails(originAirport: "LAX", destinationAirport: "JFK", startDate: Date(), endDate: Date().addingTimeInterval(3600 * 24 * 7))
        mockNetworkService = MockNetworkService()
        viewModel = FlightSearchViewModel(vacation: vacation, networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testSearchFlights_Success() {
        // Given
        let expectedFlightResponse = FlightResponse(meta: nil, data: [], dictionaries: nil)
        mockNetworkService.flightResponse = expectedFlightResponse
        
        let expectation = XCTestExpectation(description: "Search flights")
        
        // When
        viewModel.searchFlights()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAuthTokenCalled)
            XCTAssertTrue(self.mockNetworkService.fetchFlightsCalled)
            XCTAssertEqual(self.viewModel.flights.count, expectedFlightResponse.data.count)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.fetchError)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchFlights_Failure() {
        // Given
        mockNetworkService.fetchFlightsError = NSError(domain: "TestError", code: 0, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Search flights failure")
        
        // When
        viewModel.searchFlights()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAuthTokenCalled)
            XCTAssertTrue(self.mockNetworkService.fetchFlightsCalled)
            XCTAssertTrue(self.viewModel.flights.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertTrue(self.viewModel.fetchError)
            XCTAssertFalse(self.viewModel.noFlightsFound)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSearchFlights_NoFlightsFound() {
        // Given
        mockNetworkService.flightResponse = nil
        
        let expectation = XCTestExpectation(description: "Search flights no results")
        
        // When
        viewModel.searchFlights()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchAuthTokenCalled)
            XCTAssertTrue(self.mockNetworkService.fetchFlightsCalled)
            XCTAssertTrue(self.viewModel.flights.isEmpty)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.fetchError)
            XCTAssertTrue(self.viewModel.noFlightsFound)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSortByPrice() {
        // Given
        let flight1 = Flight(outboundOriginAirport: "LAX", outboundDestinationAirport: "JFK", outboundDuration: "6h", returnOriginAirport: "JFK", returnDestinationAirport: "LAX", returnDuration: "6h", price: 200.0)
        let flight2 = Flight(outboundOriginAirport: "LAX", outboundDestinationAirport: "JFK", outboundDuration: "6h", returnOriginAirport: "JFK", returnDestinationAirport: "LAX", returnDuration: "6h", price: 150.0)
        viewModel.flights = [flight1, flight2]
        
        // When
        viewModel.sortByPrice()
        
        // Then
        XCTAssertEqual(viewModel.flights[0].price, 150.0)
        XCTAssertEqual(viewModel.flights[1].price, 200.0)
    }
    
    func testSortByTotalDuration() {
        // Given
        let flight1 = Flight(outboundOriginAirport: "LAX", outboundDestinationAirport: "JFK", outboundDuration: "6H", returnOriginAirport: "JFK", returnDestinationAirport: "LAX", returnDuration: "6H", price: 200.0)
        let flight2 = Flight(outboundOriginAirport: "LAX", outboundDestinationAirport: "JFK", outboundDuration: "4H30M", returnOriginAirport: "JFK", returnDestinationAirport: "LAX", returnDuration: "5H", price: 150.0)
        viewModel.flights = [flight1, flight2]
        
        // When
        viewModel.sortByTotalDuration()
        
        // Then
        XCTAssertEqual(viewModel.flights[0].outboundDuration, "4H30M")
        XCTAssertEqual(viewModel.flights[1].outboundDuration, "6H")
    }
}
