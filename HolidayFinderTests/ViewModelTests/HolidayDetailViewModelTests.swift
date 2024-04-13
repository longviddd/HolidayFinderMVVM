//
//  HolidayDetailViewModelTests.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-01.
//

import XCTest
@testable import HolidayFinder

class HolidayDetailViewModelTests: XCTestCase {
var viewModel: HolidayDetailViewModel!
var holiday: Holiday!
    override func setUp() {
        super.setUp()
        holiday = Holiday(date: "2024-12-25", localName: "Christmas Day", name: "Christmas Day", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public", "Bank"])
        viewModel = HolidayDetailViewModel(holiday: holiday)
    }

    override func tearDown() {
        viewModel = nil
        holiday = nil
        super.tearDown()
    }

    func testGetDayOfWeek_ValidDate() {
        // Given
        let date = "2024-12-25"
        
        // When
        let dayOfWeek = viewModel.getDayOfWeek(date: date)
        
        // Then
        XCTAssertEqual(dayOfWeek, "Wednesday", "Day of week should be Wednesday for 2024-12-25")
    }

    func testGetDayOfWeek_InvalidDate() {
        // Given
        let date = "invalid-date"
        
        // When
        let dayOfWeek = viewModel.getDayOfWeek(date: date)
        
        // Then
        XCTAssertNil(dayOfWeek, "Day of week should be nil for an invalid date")
    }
}

