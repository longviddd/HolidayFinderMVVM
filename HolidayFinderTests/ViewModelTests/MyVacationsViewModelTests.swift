//
//  MyVacationsViewModelTests.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-01.
//

import XCTest
@testable import HolidayFinder

class MyVacationsViewModelTests: XCTestCase {
    var viewModel: MyVacationsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = MyVacationsViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadVacations() {
        // Given
        let vacation1 = VacationDetails(originAirport: "LAX", destinationAirport: "JFK", startDate: Date(), endDate: Date())
        let vacation2 = VacationDetails(originAirport: "SFO", destinationAirport: "ORD", startDate: Date(), endDate: Date())
        let vacations = [vacation1, vacation2]
        let data = try? JSONEncoder().encode(vacations)
        UserDefaults.standard.set(data, forKey: "vacationList")
        
        // When
        viewModel.loadVacations()
        
        // Then
        XCTAssertEqual(viewModel.vacations.count, 2)
        XCTAssertEqual(viewModel.vacations[0], vacation1)
        XCTAssertEqual(viewModel.vacations[1], vacation2)
    }
    
    func testDeleteVacation() {
        // Given
        let vacation1 = VacationDetails(originAirport: "LAX", destinationAirport: "JFK", startDate: Date(), endDate: Date())
        let vacation2 = VacationDetails(originAirport: "SFO", destinationAirport: "ORD", startDate: Date(), endDate: Date())
        viewModel.vacations = [vacation1, vacation2]
        
        // When
        viewModel.deleteVacation(vacation: vacation1)
        
        // Then
        XCTAssertEqual(viewModel.vacations.count, 1)
        XCTAssertEqual(viewModel.vacations[0], vacation2)
    }
}
