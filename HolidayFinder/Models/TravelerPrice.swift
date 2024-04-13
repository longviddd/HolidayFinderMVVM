//
//  TravelerPrice.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import Foundation
struct TravelerPrice: Codable {
    let currency: String
    let total: String
    let base: String
    let taxes: [Tax]?
}
