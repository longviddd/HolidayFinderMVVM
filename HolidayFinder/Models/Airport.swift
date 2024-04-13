//
//  Airport.swift
//  HolidayFinder
//
//  Created by long on 2024-02-10.
//


import Foundation

struct Airport: Codable, Identifiable, Hashable, Equatable {
    let id: UUID
    let icao: String
    let iata: String
    let name: String
    let city: String
    let state: String
    let country: String
    let elevation: Int
    let lat: Double
    let lon: Double
    let tz: String
    let iataCode: String

  
}
