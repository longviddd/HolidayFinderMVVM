//
//  FareDetailsBySegment.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import Foundation
struct FareDetailsBySegment: Codable {
    let segmentId: String
    let cabin: String?
    let fareBasis: String
    let `class`: String
    let includedCheckedBags: IncludedCheckedBags?
}
