//
//  Segment.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation
struct Segment: Codable  {
    let departure: FlightEndpoint
    let arrival: FlightEndpoint
    let carrierCode: String
    let number: String
    let aircraft: Aircraft
    let operating: Operating?
    let duration: String?
    let id: String
    let numberOfStops: Int
    let blacklistedInEU: Bool?
    let co2Emissions: [co2Emission]?
}
