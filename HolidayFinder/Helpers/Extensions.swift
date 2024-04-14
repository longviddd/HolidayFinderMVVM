//
//  Extensions.swift
//  HolidayFinderTCA
//
//  Created by long on 2024-03-17.
//

import Foundation
extension String {
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}
extension Itinerary {
    func toDictionary() -> [String: Any] {
        return [
            "duration": duration,
            "segments": segments.map { $0.toDictionary() }
        ]
    }
}

extension Segment {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "departure": departure.toDictionary(),
            "arrival": arrival.toDictionary(),
            "carrierCode": carrierCode,
            "number": number,
            "aircraft": aircraft.toDictionary(),
            "duration": duration,
            "id": id,
            "numberOfStops": numberOfStops,
            "blacklistedInEU": blacklistedInEU
        ]
        if let operating = operating {
            dict["operating"] = operating.toDictionary()
        }
        return dict
    }
}

extension FlightEndpoint {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "iataCode": iataCode,
            "at": at
        ]
        if let terminal = terminal {
            dict["terminal"] = terminal
        }
        return dict
    }
}

extension Aircraft {
    func toDictionary() -> [String: Any] {
        return ["code": code]
    }
}

extension Operating {
    func toDictionary() -> [String: Any] {
        return ["carrierCode": carrierCode]
    }
}

extension Price {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "currency": currency,
            "total": total,
            "base": base,
            "fees": fees.map { $0.toDictionary() },
            "grandTotal": grandTotal
        ]
        if let billingCurrency = billingCurrency {
            dict["billingCurrency"] = billingCurrency
        }
        return dict
    }
}

extension Fee {
    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "type": type
        ]
    }
}

extension FlightAirportDetail{
    enum CodingKeys: String, CodingKey {
        case iataCode
        case terminal
        case cityCode
        case countryCode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        iataCode = try container.decode(String.self, forKey: .iataCode)
        terminal = try container.decodeIfPresent(String.self, forKey: .terminal)

        if let locationDictionary = decoder.userInfo[CodingUserInfoKey(rawValue: "locationDictionary")!] as? [String: [String: String]] {
            let airportDetails = locationDictionary[iataCode] ?? [:]
            cityCode = airportDetails["cityCode"] ?? ""
            countryCode = airportDetails["countryCode"] ?? ""
        } else {
            cityCode = ""
            countryCode = ""
        }
    }
}

extension PricingOptions {
    func toDictionary() -> [String: Any] {
        return [
            "fareType": fareType,
            "includedCheckedBagsOnly": includedCheckedBagsOnly
        ]
    }
}

extension TravelerPricing {
    func toDictionary() -> [String: Any] {
        return [
            "travelerId": travelerId,
            "fareOption": fareOption,
            "travelerType": travelerType,
            "price": price.toDictionary(),
            "fareDetailsBySegment": fareDetailsBySegment.map { $0.toDictionary() }
        ]
    }
}

extension TravelerPrice {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "currency": currency,
            "total": total,
            "base": base
        ]
        if let taxes = taxes {
            dict["taxes"] = taxes.map { $0.toDictionary() }
        }
        return dict
    }
}

extension Tax {
    func toDictionary() -> [String: Any] {
        return [
            "amount": amount,
            "code": code
        ]
    }
}

extension FareDetailsBySegment {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "segmentId": segmentId,
            "cabin": cabin,
            "fareBasis": fareBasis,
            "class": `class`
        ]
        if let includedCheckedBags = includedCheckedBags {
            dict["includedCheckedBags"] = includedCheckedBags.toDictionary()
        }
        return dict
    }
}

extension IncludedCheckedBags {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let quantity = quantity {
            dict["quantity"] = quantity
        }
        if let weight = weight {
            dict["weight"] = weight
        }
        if let weightUnit = weightUnit {
            dict["weightUnit"] = weightUnit
        }
        return dict
    }
}
extension Holiday: Equatable {
    static func == (lhs: Holiday, rhs: Holiday) -> Bool {
        lhs.date == rhs.date &&
        lhs.localName == rhs.localName &&
        lhs.name == rhs.name &&
        lhs.countryCode == rhs.countryCode &&
        lhs.fixed == rhs.fixed &&
        lhs.global == rhs.global &&
        lhs.counties == rhs.counties &&
        lhs.launchYear == rhs.launchYear &&
        lhs.types == rhs.types
    }
    static func isEqual(_ lhs: Holiday, _ rhs: Holiday) -> Bool {
        return lhs.date == rhs.date &&
            lhs.localName == rhs.localName &&
            lhs.name == rhs.name &&
            lhs.countryCode == rhs.countryCode &&
            lhs.fixed == rhs.fixed &&
            lhs.global == rhs.global &&
            lhs.counties == rhs.counties &&
            lhs.launchYear == rhs.launchYear &&
            lhs.types == rhs.types
    }
}
extension VacationDetails: Equatable, Hashable{
    static func == (lhs: VacationDetails, rhs: VacationDetails) -> Bool {
        return lhs.originAirport == rhs.originAirport &&
            lhs.destinationAirport == rhs.destinationAirport &&
            lhs.startDate == rhs.startDate &&
            lhs.endDate == rhs.endDate
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(originAirport)
        hasher.combine(destinationAirport)
        hasher.combine(startDate)
        hasher.combine(endDate)
    }
}

extension FlightResponsePrice: Equatable{
    static func == (lhs: FlightResponsePrice, rhs: FlightResponsePrice) -> Bool {
        return lhs.data == rhs.data && lhs.dictionaries == rhs.dictionaries
    }
}
extension FlightResponsePriceData: Equatable{
    static func == (lhs: FlightResponsePriceData, rhs: FlightResponsePriceData) -> Bool {
        return lhs.type == rhs.type && lhs.flightOffers == rhs.flightOffers
    }
}
extension FlightOffer: Hashable{
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Country: Equatable{
    static func == (lhs: Country, rhs: Country) -> Bool {
        return lhs.name == rhs.name &&
            lhs.countryCode == rhs.countryCode
    }
}
// Make Flight struct Equatable
extension Flight: Equatable {
    static func == (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.outboundOriginAirport == rhs.outboundOriginAirport &&
            lhs.outboundDestinationAirport == rhs.outboundDestinationAirport &&
            lhs.outboundDuration == rhs.outboundDuration &&
            lhs.returnOriginAirport == rhs.returnOriginAirport &&
            lhs.returnDestinationAirport == rhs.returnDestinationAirport &&
            lhs.returnDuration == rhs.returnDuration &&
            lhs.price == rhs.price
    }
}

extension Airport{
    enum CodingKeys: String, CodingKey {
        case icao, iata, name, city, state, country, elevation, lat, lon, tz
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

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
        iataCode = try container.decodeIfPresent(String.self, forKey: .iata) ?? "N/A"
    }
    static func == (lhs: Airport, rhs: Airport) -> Bool {
        return lhs.icao == rhs.icao &&
            lhs.iata == rhs.iata &&
            lhs.name == rhs.name &&
            lhs.city == rhs.city &&
            lhs.state == rhs.state &&
            lhs.country == rhs.country &&
            lhs.elevation == rhs.elevation &&
            lhs.lat == rhs.lat &&
            lhs.lon == rhs.lon &&
            lhs.tz == rhs.tz &&
            lhs.iataCode == rhs.iataCode
    }
}

// Make FlightResponse struct Equatable
extension FlightResponse: Equatable {
    static func == (lhs: FlightResponse, rhs: FlightResponse) -> Bool {
        return lhs.meta == rhs.meta &&
            lhs.data == rhs.data &&
            lhs.dictionaries == rhs.dictionaries
    }
}


extension Meta: Equatable {
    static func == (lhs: Meta, rhs: Meta) -> Bool {
        return lhs.count == rhs.count &&
            lhs.links == rhs.links
    }
}

extension Links: Equatable {
    static func == (lhs: Links, rhs: Links) -> Bool {
        return lhs.`self` == rhs.`self`
    }
}


extension FlightOffer: Equatable {
    static func == (lhs: FlightOffer, rhs: FlightOffer) -> Bool {
        return lhs.id == rhs.id &&
            lhs.type == rhs.type &&
            lhs.source == rhs.source &&
            lhs.instantTicketingRequired == rhs.instantTicketingRequired &&
            lhs.nonHomogeneous == rhs.nonHomogeneous &&
            lhs.oneWay == rhs.oneWay &&
            lhs.lastTicketingDate == rhs.lastTicketingDate &&
            lhs.lastTicketingDateTime == rhs.lastTicketingDateTime &&
            lhs.numberOfBookableSeats == rhs.numberOfBookableSeats &&
            lhs.itineraries == rhs.itineraries &&
            lhs.price == rhs.price &&
            lhs.pricingOptions == rhs.pricingOptions &&
            lhs.validatingAirlineCodes == rhs.validatingAirlineCodes &&
            lhs.travelerPricings == rhs.travelerPricings
    }
}


extension Itinerary: Equatable {
    static func == (lhs: Itinerary, rhs: Itinerary) -> Bool {
        return lhs.duration == rhs.duration &&
            lhs.segments == rhs.segments
    }
}


extension Segment: Equatable {
    static func == (lhs: Segment, rhs: Segment) -> Bool {
        return lhs.departure == rhs.departure &&
            lhs.arrival == rhs.arrival &&
            lhs.carrierCode == rhs.carrierCode &&
            lhs.number == rhs.number &&
            lhs.aircraft == rhs.aircraft &&
            lhs.operating == rhs.operating &&
            lhs.duration == rhs.duration &&
            lhs.id == rhs.id &&
            lhs.numberOfStops == rhs.numberOfStops &&
            lhs.blacklistedInEU == rhs.blacklistedInEU &&
            lhs.co2Emissions == rhs.co2Emissions
    }
}


extension FlightEndpoint: Equatable {
    static func == (lhs: FlightEndpoint, rhs: FlightEndpoint) -> Bool {
        return lhs.iataCode == rhs.iataCode &&
            lhs.terminal == rhs.terminal &&
            lhs.at == rhs.at
    }
}


extension Aircraft: Equatable {
    static func == (lhs: Aircraft, rhs: Aircraft) -> Bool {
        return lhs.code == rhs.code
    }
}


extension Operating: Equatable {
    static func == (lhs: Operating, rhs: Operating) -> Bool {
        return lhs.carrierCode == rhs.carrierCode
    }
}


extension Price: Equatable {
    static func == (lhs: Price, rhs: Price) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.total == rhs.total &&
            lhs.base == rhs.base &&
            lhs.fees == rhs.fees &&
            lhs.grandTotal == rhs.grandTotal &&
            lhs.billingCurrency == rhs.billingCurrency
    }
}


extension Fee: Equatable {
    static func == (lhs: Fee, rhs: Fee) -> Bool {
        return lhs.amount == rhs.amount &&
            lhs.type == rhs.type
    }
}


extension Dictionaries: Equatable {
    static func == (lhs: Dictionaries, rhs: Dictionaries) -> Bool {
        return lhs.locations == rhs.locations &&
            lhs.aircraft == rhs.aircraft &&
            lhs.currencies == rhs.currencies &&
            lhs.carriers == rhs.carriers
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.cityCode == rhs.cityCode &&
            lhs.countryCode == rhs.countryCode
    }
}


extension PricingOptions: Equatable {
    static func == (lhs: PricingOptions, rhs: PricingOptions) -> Bool {
        return lhs.fareType == rhs.fareType &&
            lhs.includedCheckedBagsOnly == rhs.includedCheckedBagsOnly
    }
}


extension TravelerPricing: Equatable {
    static func == (lhs: TravelerPricing, rhs: TravelerPricing) -> Bool {
        return lhs.travelerId == rhs.travelerId &&
            lhs.fareOption == rhs.fareOption &&
            lhs.travelerType == rhs.travelerType &&
            lhs.price == rhs.price &&
            lhs.fareDetailsBySegment == rhs.fareDetailsBySegment
    }
}


extension TravelerPrice: Equatable {
    static func == (lhs: TravelerPrice, rhs: TravelerPrice) -> Bool {
        return lhs.currency == rhs.currency &&
            lhs.total == rhs.total &&
            lhs.base == rhs.base &&
            lhs.taxes == rhs.taxes
    }
}


extension Tax: Equatable {
    static func == (lhs: Tax, rhs: Tax) -> Bool {
        return lhs.amount == rhs.amount &&
            lhs.code == rhs.code
    }
}


extension FareDetailsBySegment: Equatable {
    static func == (lhs: FareDetailsBySegment, rhs: FareDetailsBySegment) -> Bool {
        return lhs.segmentId == rhs.segmentId &&
            lhs.cabin == rhs.cabin &&
            lhs.fareBasis == rhs.fareBasis &&
            lhs.class == rhs.class &&
            lhs.includedCheckedBags == rhs.includedCheckedBags
    }
}


extension IncludedCheckedBags: Equatable {
    static func == (lhs: IncludedCheckedBags, rhs: IncludedCheckedBags) -> Bool {
        return lhs.quantity == rhs.quantity &&
            lhs.weight == rhs.weight &&
            lhs.weightUnit == rhs.weightUnit
    }
}


extension co2Emission: Equatable {
    static func == (lhs: co2Emission, rhs: co2Emission) -> Bool {
        return lhs.weight == rhs.weight &&
            lhs.weightUnit == rhs.weightUnit &&
            lhs.cabin == rhs.cabin
    }
}

extension Holiday{
    enum CodingKeys: String, CodingKey {
        case date, localName, name, countryCode, fixed, global, counties, launchYear, types
    }
}
