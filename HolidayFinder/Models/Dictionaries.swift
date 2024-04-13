//
//  Dictionaries.swift
//  HolidayFinder
//
//  Created by long on 2024-03-10.
//

import Foundation
struct Dictionaries: Codable {
    let locations: [String: Location]
    let aircraft: [String: String]?
    let currencies: [String: String]?
    let carriers: [String: String]?

}
