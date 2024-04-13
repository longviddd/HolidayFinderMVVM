//
//  Price.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation
struct Price: Codable {
    let currency: String
    let total: String
    let base: String
    let fees: [Fee]
    let grandTotal: String
    let billingCurrency: String?
}
