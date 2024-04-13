//
//  Holiday.swift
//  HolidayFinder
//
//  Created by long on 2024-03-02.
//

import Foundation
struct Holiday: Identifiable, Codable {
    let id: UUID = UUID()
    let date: String
    let localName: String
    let name: String
    let countryCode: String
    let fixed: Bool
    let global: Bool
    let counties: [String]?
    let launchYear: Int?
    let types: [String]


}

