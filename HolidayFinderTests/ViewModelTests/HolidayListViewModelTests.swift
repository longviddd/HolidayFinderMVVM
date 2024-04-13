import XCTest
@testable import HolidayFinder

class HolidayListViewModelTests: XCTestCase {
    var viewModel: HolidayListViewModel!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = HolidayListViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchHolidays_Success() {
        // Given
        let expectedHolidays = [
            Holiday(date: "2024-01-01", localName: "New Year's Day", name: "New Year's Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"]),
            Holiday(date: "2024-07-04", localName: "Independence Day", name: "Independence Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        ]
        mockNetworkService.fetchHolidaysHandler = { countryCode, year, completion in
            completion(expectedHolidays)
        }
        
        let expectation = XCTestExpectation(description: "Fetch holidays")
        
        // When
        viewModel.fetchHolidays(forCountry: "US", year: "2024", upcomingOnly: false)
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.mockNetworkService.fetchHolidaysCalled)
            XCTAssertEqual(self.viewModel.holidays.count, expectedHolidays.count)
            XCTAssertEqual(self.viewModel.holidays, expectedHolidays)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchHolidays_Failure() {
        // Given
        mockNetworkService.fetchHolidaysHandler = { countryCode, year, completion in
            completion(nil)
        }
        
        // When
        viewModel.fetchHolidays(forCountry: "US", year: "2024", upcomingOnly: false)
        
        // Then
        XCTAssertTrue(mockNetworkService.fetchHolidaysCalled)
        XCTAssertTrue(viewModel.holidays.isEmpty)
    }
    
    func testLoadSearchParametersAndFetchHolidays() {
        // Given
        let searchParameters = ["selectedCountry": "US", "selectedYear": "2024"]
        UserDefaults.standard.set(searchParameters, forKey: "searchParameters")
        mockNetworkService.fetchHolidaysHandler = { countryCode, year, completion in
            XCTAssertEqual(countryCode, "US")
            XCTAssertEqual(year, "2024")
            completion([])
        }
        
        // When
        viewModel.loadSearchParametersAndFetchHolidays()
        
        // Then
        XCTAssertTrue(mockNetworkService.fetchHolidaysCalled)
    }
}
