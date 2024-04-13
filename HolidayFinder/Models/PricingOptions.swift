//
//  PricingOptions.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import Foundation
struct PricingOptions: Codable {
    let fareType: [String]
    let includedCheckedBagsOnly: Bool
}
