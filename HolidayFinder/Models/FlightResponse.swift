//
//  FlightResponse.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation
struct FlightResponse: Codable {
    let meta: Meta?
    let data: [FlightOffer]
    let dictionaries: Dictionaries?
}
struct FlightResponsePrice: Codable {
    let data: FlightResponsePriceData
    let dictionaries: Dictionaries?
}

struct FlightResponsePriceData: Codable {
    let type: String
    let flightOffers: [FlightOffer]

}
