//
//  TravelerPricing.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import Foundation
struct TravelerPricing: Codable {
    let travelerId: String
    let fareOption: String
    let travelerType: String
    let price: TravelerPrice
    let fareDetailsBySegment: [FareDetailsBySegment]
}
