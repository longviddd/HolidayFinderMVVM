//
//  FlightOffer.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation
struct FlightOffer: Codable {
    let type: String
    let id: String
    let source: String
    let instantTicketingRequired: Bool
    let nonHomogeneous: Bool
    let oneWay: Bool?
    let lastTicketingDate: String
    let lastTicketingDateTime: String?
    let numberOfBookableSeats: Int?
    let itineraries: [Itinerary]
    let price: Price
    let pricingOptions: PricingOptions
    let validatingAirlineCodes: [String]
    let travelerPricings: [TravelerPricing]

}
