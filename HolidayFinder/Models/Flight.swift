//
//  Flight.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation
struct Flight: Identifiable, Hashable {
    let id = UUID()
    let outboundOriginAirport: String
    let outboundDestinationAirport: String
    let outboundDuration: String
    let returnOriginAirport: String
    let returnDestinationAirport: String
    let returnDuration: String
    let price: Double
}
