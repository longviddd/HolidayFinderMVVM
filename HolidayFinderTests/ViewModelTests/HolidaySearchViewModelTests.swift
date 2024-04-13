//
//  HolidaySearchViewModelTests.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-01.
//

import XCTest
@testable import HolidayFinder

class HolidaySearchViewModelTests: XCTestCase {
    var viewModel: HolidaySearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = HolidaySearchViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchVacationLocations() {
        // Given
        let expectation = XCTestExpectation(description: "Fetch vacation locations")
        
        // When
        viewModel.fetchVacationLocations()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertFalse(self.viewModel.vacationLocationsJson.isEmpty)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testValidateYearInput_ValidYear() {
        // Given
        let validYear = "2024"
        
        // When
        viewModel.validateYearInput(text: validYear)
        
        // Then
        XCTAssertTrue(viewModel.isYearValid)
        XCTAssertEqual(viewModel.yearSearch, validYear)
    }
    
    func testValidateYearInput_InvalidYear() {
        // Given
        let invalidYear = "2000"
        
        // When
        viewModel.validateYearInput(text: invalidYear)
        
        // Then
        XCTAssertFalse(viewModel.isYearValid)
    }
    
    func testHandleUpcomingCurrentYearOnlyChange_True() {
        // Given
        let currentYear = String(Calendar.current.component(.year, from: Date()))
        
        // When
        viewModel.handleUpcomingCurrentYearOnlyChange(newValue: true)
        
        // Then
        XCTAssertTrue(viewModel.upcomingCurrentYearOnly)
        XCTAssertEqual(viewModel.yearSearch, currentYear)
    }
    
    func testHandleUpcomingCurrentYearOnlyChange_False() {
        // Given
        let initialYear = "2025"
        viewModel.yearSearch = initialYear
        
        // When
        viewModel.handleUpcomingCurrentYearOnlyChange(newValue: false)
        
        // Then
        XCTAssertFalse(viewModel.upcomingCurrentYearOnly)
        XCTAssertEqual(viewModel.yearSearch, initialYear)
    }
    
    func testSubmitSearch_ValidYear() {
        // Given
        viewModel.yearSearch = "2024"
        viewModel.isYearValid = true
        
        // When
        viewModel.submitSearch()
        
        // Then
        XCTAssertTrue(viewModel.shouldNavigate)
    }
    
    func testSubmitSearch_InvalidYear() {
        // Given
        viewModel.yearSearch = "2000"
        viewModel.isYearValid = false
        
        // When
        viewModel.submitSearch()
        
        // Then
        XCTAssertFalse(viewModel.shouldNavigate)
    }
}
