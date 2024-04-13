//
//  FlightEndPoint.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import Foundation
struct FlightEndpoint: Codable {
    let iataCode: String
    let terminal: String?
    let at: String
}
