//
//  Airport.swift
//  HolidayFinder
//
//  Created by long on 2024-02-10.
//


import Foundation

struct Airport: Codable, Identifiable {
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

    enum CodingKeys: String, CodingKey {
        case icao, iata, name, city, state, country, elevation, lat, lon, tz
    }

    // Provide a custom initializer to decode from the Decoder instance
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode each property, providing a default value if the decode fails
        id = UUID()
        icao = try container.decodeIfPresent(String.self, forKey: .icao) ?? "N/A"
        iata = try container.decodeIfPresent(String.self, forKey: .iata) ?? "N/A"
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Unknown"
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? "Unknown"
        state = try container.decodeIfPresent(String.self, forKey: .state) ?? "Unknown"
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? "Unknown"
        elevation = try container.decodeIfPresent(Int.self, forKey: .elevation) ?? 0
        lat = try container.decodeIfPresent(Double.self, forKey: .lat) ?? 0.0
        lon = try container.decodeIfPresent(Double.self, forKey: .lon) ?? 0.0
        tz = try container.decodeIfPresent(String.self, forKey: .tz) ?? "UTC"
    }
}
