//
//  FlightAirportDetail.swift
//  HolidayFinder
//
//  Created by long on 2024-03-10.
//

import Foundation
struct FlightAirportDetail: Codable {
    let iataCode: String
    let terminal: String?
    let cityCode: String
    let countryCode: String

}
