//
//  ExtensionsTests.swift
//  HolidayFinderTests
//
//  Created by long on 2024-04-10.
//

import XCTest
@testable import HolidayFinder

class ExtensionsTests: XCTestCase {
    
    func testStringToDate() {
        let dateString = "2024-03-17"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0) // Set time zone to UTC
        let expectedDate = dateFormatter.date(from: dateString)
        XCTAssertEqual(dateString.toDate(), expectedDate)
    }
    
    
    func testItineraryToDictionary() {
        // Given
        let segments = [Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: "2", at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: Operating(carrierCode: "BB"), duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)]
        let itinerary = Itinerary(duration: "PT2H", segments: segments)
        
        // When
        let dictionary = itinerary.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["duration"] as? String, "PT2H")
        XCTAssertEqual((dictionary["segments"] as? [[String: Any]])?.count, 1)
    }
    
    func testSegmentToDictionary() {
        // Given
        let segment = Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: "2", at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: Operating(carrierCode: "BB"), duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        
        // When
        let dictionary = segment.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["carrierCode"] as? String, "AA")
        XCTAssertEqual(dictionary["number"] as? String, "123")
        XCTAssertEqual(dictionary["duration"] as? String, "PT2H")
        XCTAssertEqual(dictionary["id"] as? String, "1")
        XCTAssertEqual(dictionary["numberOfStops"] as? Int, 0)
        XCTAssertEqual(dictionary["blacklistedInEU"] as? Bool, false)
    }
    
    func testFlightEndpointToDictionary() {
        // Given
        let flightEndpoint = FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00")
        
        // When
        let dictionary = flightEndpoint.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["iataCode"] as? String, "ABC")
        XCTAssertEqual(dictionary["terminal"] as? String, "1")
        XCTAssertEqual(dictionary["at"] as? String, "2024-03-17T10:00:00")
    }
    
    func testAircraftToDictionary() {
        // Given
        let aircraft = Aircraft(code: "747")
        
        // When
        let dictionary = aircraft.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["code"] as? String, "747")
    }
    
    func testOperatingToDictionary() {
        // Given
        let operating = Operating(carrierCode: "AA")
        
        // When
        let dictionary = operating.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["carrierCode"] as? String, "AA")
    }
    
    func testPriceToDictionary() {
        // Given
        let price = Price(currency: "USD", total: "100.00", base: "80.00", fees: [Fee(amount: "20.00", type: "tax")], grandTotal: "100.00", billingCurrency: "USD")
        
        // When
        let dictionary = price.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["currency"] as? String, "USD")
        XCTAssertEqual(dictionary["total"] as? String, "100.00")
        XCTAssertEqual(dictionary["base"] as? String, "80.00")
        XCTAssertEqual((dictionary["fees"] as? [[String: String]])?.count, 1)
        XCTAssertEqual(dictionary["grandTotal"] as? String, "100.00")
        XCTAssertEqual(dictionary["billingCurrency"] as? String, "USD")
    }
    
    func testFeeToDictionary() {
        // Given
        let fee = Fee(amount: "20.00", type: "tax")
        
        // When
        let dictionary = fee.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["amount"] as? String, "20.00")
        XCTAssertEqual(dictionary["type"] as? String, "tax")
    }
    
    func testPricingOptionsToDictionary() {
        // Given
        let pricingOptions = PricingOptions(fareType: ["economy"], includedCheckedBagsOnly: true)
        
        // When
        let dictionary = pricingOptions.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["fareType"] as? [String], ["economy"])
        XCTAssertEqual(dictionary["includedCheckedBagsOnly"] as? Bool, true)
    }
    
    func testTravelerPricingToDictionary() {
        // Given
        let price = TravelerPrice(currency: "USD", total: "100.00", base: "80.00", taxes: nil)
        let fareDetailsBySegment = [FareDetailsBySegment(segmentId: "1", cabin: "economy", fareBasis: "ABC123", class: "Y", includedCheckedBags: nil)]
        let travelerPricing = TravelerPricing(travelerId: "1", fareOption: "standard", travelerType: "adult", price: price, fareDetailsBySegment: fareDetailsBySegment)
        
        // When
        let dictionary = travelerPricing.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["travelerId"] as? String, "1")
        XCTAssertEqual(dictionary["fareOption"] as? String, "standard")
        XCTAssertEqual(dictionary["travelerType"] as? String, "adult")
        XCTAssertEqual((dictionary["fareDetailsBySegment"] as? [[String: Any]])?.count, 1)
    }
    
    func testTravelerPriceToDictionary() {
        // Given
        let price = TravelerPrice(currency: "USD", total: "100.00", base: "80.00", taxes: [Tax(amount: "20.00", code: "TX")])
        
        // When
        let dictionary = price.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["currency"] as? String, "USD")
        XCTAssertEqual(dictionary["total"] as? String, "100.00")
        XCTAssertEqual(dictionary["base"] as? String, "80.00")
        XCTAssertEqual((dictionary["taxes"] as? [[String: String]])?.count, 1)
    }
    
    func testTaxToDictionary() {
        // Given
        let tax = Tax(amount: "20.00", code: "TX")
        
        // When
        let dictionary = tax.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["amount"] as? String, "20.00")
        XCTAssertEqual(dictionary["code"] as? String, "TX")
    }
    
    func testFareDetailsBySegmentToDictionary() {
        // Given
        let fareDetailsBySegment = FareDetailsBySegment(segmentId: "1", cabin: "economy", fareBasis: "ABC123", class: "Y", includedCheckedBags: IncludedCheckedBags(quantity: 2, weight: 23, weightUnit: "kg"))
        
        // When
        let dictionary = fareDetailsBySegment.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["segmentId"] as? String, "1")
        XCTAssertEqual(dictionary["cabin"] as? String, "economy")
        XCTAssertEqual(dictionary["fareBasis"] as? String, "ABC123")
        XCTAssertEqual(dictionary["class"] as? String, "Y")
        XCTAssertNotNil(dictionary["includedCheckedBags"])
    }
    
    func testIncludedCheckedBagsToDictionary() {
        // Given
        let includedCheckedBags = IncludedCheckedBags(quantity: 2, weight: 23, weightUnit: "kg")
        
        // When
        let dictionary = includedCheckedBags.toDictionary()
        
        // Then
        XCTAssertEqual(dictionary["quantity"] as? Int, 2)
        XCTAssertEqual(dictionary["weight"] as? Int, 23)
        XCTAssertEqual(dictionary["weightUnit"] as? String, "kg")
    }
    
    func testHolidayEquatable() {
        // Given
        let holiday1 = Holiday(date: "2024-03-17", localName: "Test Holiday", name: "Test Holiday", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        let holiday2 = Holiday(date: "2024-03-17", localName: "Test Holiday", name: "Test Holiday", countryCode: "US", fixed: true, global: true, counties: nil, launchYear: nil, types: ["Public"])
        let holiday3 = Holiday(date: "2024-03-18", localName: "Another Holiday", name: "Another Holiday", countryCode: "CA", fixed: false, global: false, counties: ["County1"], launchYear: 2022, types: ["Bank"])
        
        // Then
        XCTAssertEqual(holiday1, holiday2)
        XCTAssertNotEqual(holiday1, holiday3)
    }
    
    func testVacationDetailsEquatable() {
        // Given
        let vacation1 = VacationDetails(originAirport: "ABC", destinationAirport: "XYZ", startDate: Date(), endDate: Date())
        let vacation2 = VacationDetails(originAirport: "ABC", destinationAirport: "XYZ", startDate: Date(), endDate: Date())
        let vacation3 = VacationDetails(originAirport: "DEF", destinationAirport: "UVW", startDate: Date(), endDate: Date())
        
        // Then
        XCTAssertEqual(vacation1, vacation2)
        XCTAssertNotEqual(vacation1, vacation3)
    }
    
    func testFlightResponsePriceEquatable() {
        // Given
        let flightResponsePrice1 = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        let flightResponsePrice2 = FlightResponsePrice(data: FlightResponsePriceData(type: "flight-offer", flightOffers: []), dictionaries: nil)
        let flightResponsePrice3 = FlightResponsePrice(data: FlightResponsePriceData(type: "another-type", flightOffers: []), dictionaries: Dictionaries(locations: ["ABC": Location(cityCode: "City1", countryCode: "Country1")], aircraft: nil, currencies: nil, carriers: nil))
        
        // Then
        XCTAssertEqual(flightResponsePrice1, flightResponsePrice2)
        XCTAssertNotEqual(flightResponsePrice1, flightResponsePrice3)
    }
    
    func testFlightResponsePriceDataEquatable() {
        // Given
        let flightResponsePriceData1 = FlightResponsePriceData(type: "flight-offer", flightOffers: [])
        let flightResponsePriceData2 = FlightResponsePriceData(type: "flight-offer", flightOffers: [])
        let flightResponsePriceData3 = FlightResponsePriceData(type: "another-type", flightOffers: [FlightOffer(type: "flight-offer", id: "1", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false), validatingAirlineCodes: ["AA"], travelerPricings: [])])
        
        // Then
        XCTAssertEqual(flightResponsePriceData1, flightResponsePriceData2)
        XCTAssertNotEqual(flightResponsePriceData1, flightResponsePriceData3)
    }
    
    func testFlightOfferHashable() {
        // Given
        let flightOffer1 = FlightOffer(type: "flight-offer", id: "1", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false), validatingAirlineCodes: ["AA"], travelerPricings: [])
        let flightOffer2 = FlightOffer(type: "flight-offer", id: "1", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false), validatingAirlineCodes: ["AA"], travelerPricings: [])
        let flightOffer3 = FlightOffer(type: "flight-offer", id: "2", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-18", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "200.00", base: "180.00", fees: [], grandTotal: "200.00", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false), validatingAirlineCodes: ["BA"], travelerPricings: [])
        
        // When
        let set: Set<FlightOffer> = [flightOffer1, flightOffer2, flightOffer3]
        
        // Then
        XCTAssertEqual(set.count, 2)
    }
    
    func testCountryEquatable() {
        // Given
        let country1 = Country(name: "United States", countryCode: "US")
        let country2 = Country(name: "United States", countryCode: "US")
        let country3 = Country(name: "Canada", countryCode: "CA")
        
        // Then
        XCTAssertEqual(country1, country2)
        XCTAssertNotEqual(country1, country3)
    }
    
    func testFlightEquatable() {
        // Given
        let flight1 = Flight(outboundOriginAirport: "ABC", outboundDestinationAirport: "XYZ", outboundDuration: "PT2H", returnOriginAirport: "XYZ", returnDestinationAirport: "ABC", returnDuration: "PT2H30M", price: 100.0)
        let flight2 = Flight(outboundOriginAirport: "ABC", outboundDestinationAirport: "XYZ", outboundDuration: "PT2H", returnOriginAirport: "XYZ", returnDestinationAirport: "ABC", returnDuration: "PT2H30M", price: 100.0)
        let flight3 = Flight(outboundOriginAirport: "DEF", outboundDestinationAirport: "UVW", outboundDuration: "PT3H", returnOriginAirport: "UVW", returnDestinationAirport: "DEF", returnDuration: "PT3H30M", price: 200.0)
        
        // Then
        XCTAssertEqual(flight1, flight2)
        XCTAssertNotEqual(flight1, flight3)
    }
    
    func testFlightResponseEquatable() {
        // Given
        let flightResponse1 = FlightResponse(meta: Meta(count: 1, links: Links(self: "https://example.com")), data: [], dictionaries: Dictionaries(locations: ["ABC": Location(cityCode: "City1", countryCode: "Country1")], aircraft: ["747": "Boeing 747"], currencies: ["USD": "US Dollar"], carriers: ["AA": "American Airlines"]))
        let flightResponse2 = FlightResponse(meta: Meta(count: 1, links: Links(self: "https://example.com")), data: [], dictionaries: Dictionaries(locations: ["ABC": Location(cityCode: "City1", countryCode: "Country1")], aircraft: ["747": "Boeing 747"], currencies: ["USD": "US Dollar"], carriers: ["AA": "American Airlines"]))
        let flightResponse3 = FlightResponse(meta: Meta(count: 2, links: Links(self: "https://example.com/other")), data: [FlightOffer(type: "flight-offer", id: "1", source: "GDS", instantTicketingRequired: false, nonHomogeneous: false, oneWay: false, lastTicketingDate: "2024-03-17", lastTicketingDateTime: nil, numberOfBookableSeats: nil, itineraries: [], price: Price(currency: "USD", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: nil), pricingOptions: PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false), validatingAirlineCodes: ["AA"], travelerPricings: [])], dictionaries: nil)
        
        // Then
        XCTAssertEqual(flightResponse1, flightResponse2)
        XCTAssertNotEqual(flightResponse1, flightResponse3)
    }
    
    func testMetaEquatable() {
        // Given
        let meta1 = Meta(count: 1, links: Links(self: "https://example.com"))
        let meta2 = Meta(count: 1, links: Links(self: "https://example.com"))
        let meta3 = Meta(count: 2, links: Links(self: "https://example.com/other"))
        
        // Then
        XCTAssertEqual(meta1, meta2)
        XCTAssertNotEqual(meta1, meta3)
    }
    
    func testLinksEquatable() {
        // Given
        let links1 = Links(self: "https://example.com")
        let links2 = Links(self: "https://example.com")
        let links3 = Links(self: "https://example.com/other")
        
        // Then
        XCTAssertEqual(links1, links2)
        XCTAssertNotEqual(links1, links3)
    }
    
    func testItineraryEquatable() {
        // Given
        let itinerary1 = Itinerary(duration: "PT2H", segments: [])
        let itinerary2 = Itinerary(duration: "PT2H", segments: [])
        let itinerary3 = Itinerary(duration: "PT3H", segments: [Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: "2", at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: Operating(carrierCode: "BB"), duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)])
        
        // Then
        XCTAssertEqual(itinerary1, itinerary2)
        XCTAssertNotEqual(itinerary1, itinerary3)
    }
    
    func testSegmentEquatable() {
        // Given
        let segment1 = Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: "2", at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: Operating(carrierCode: "BB"), duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        let segment2 = Segment(departure: FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00"), arrival: FlightEndpoint(iataCode: "XYZ", terminal: "2", at: "2024-03-17T12:00:00"), carrierCode: "AA", number: "123", aircraft: Aircraft(code: "747"), operating: Operating(carrierCode: "BB"), duration: "PT2H", id: "1", numberOfStops: 0, blacklistedInEU: false, co2Emissions: nil)
        let segment3 = Segment(departure: FlightEndpoint(iataCode: "DEF", terminal: "3", at: "2024-03-18T11:00:00"), arrival: FlightEndpoint(iataCode: "UVW", terminal: "4", at: "2024-03-18T14:00:00"), carrierCode: "CC", number: "456", aircraft: Aircraft(code: "320"), operating: Operating(carrierCode: "DD"), duration: "PT3H", id: "2", numberOfStops: 1, blacklistedInEU: true, co2Emissions: nil)
        
        // Then
        XCTAssertEqual(segment1, segment2)
        XCTAssertNotEqual(segment1, segment3)
    }
    
    func testFlightEndpointEquatable() {
        // Given
        let flightEndpoint1 = FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00")
        let flightEndpoint2 = FlightEndpoint(iataCode: "ABC", terminal: "1", at: "2024-03-17T10:00:00")
        let flightEndpoint3 = FlightEndpoint(iataCode: "XYZ", terminal: "2", at: "2024-03-18T12:00:00")
        
        // Then
        XCTAssertEqual(flightEndpoint1, flightEndpoint2)
        XCTAssertNotEqual(flightEndpoint1, flightEndpoint3)
    }
    
    func testAircraftEquatable() {
        // Given
        let aircraft1 = Aircraft(code: "747")
        let aircraft2 = Aircraft(code: "747")
        let aircraft3 = Aircraft(code: "320")
        
        // Then
        XCTAssertEqual(aircraft1, aircraft2)
        XCTAssertNotEqual(aircraft1, aircraft3)
    }
    
    func testOperatingEquatable() {
        // Given
        let operating1 = Operating(carrierCode: "AA")
        let operating2 = Operating(carrierCode: "AA")
        let operating3 = Operating(carrierCode: "BB")
        
        // Then
        XCTAssertEqual(operating1, operating2)
        XCTAssertNotEqual(operating1, operating3)
    }
    
    func testPriceEquatable() {
        // Given
        let price1 = Price(currency: "USD", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: "USD")
        let price2 = Price(currency: "USD", total: "100.00", base: "80.00", fees: [], grandTotal: "100.00", billingCurrency: "USD")
        let price3 = Price(currency: "EUR", total: "90.00", base: "70.00", fees: [Fee(amount: "20.00", type: "tax")], grandTotal: "90.00", billingCurrency: "EUR")
        
        // Then
        XCTAssertEqual(price1, price2)
        XCTAssertNotEqual(price1, price3)
    }
    
    func testFeeEquatable() {
        // Given
        let fee1 = Fee(amount: "20.00", type: "tax")
        let fee2 = Fee(amount: "20.00", type: "tax")
        let fee3 = Fee(amount: "30.00", type: "service")
        
        // Then
        XCTAssertEqual(fee1, fee2)
        XCTAssertNotEqual(fee1, fee3)
    }
    
    func testDictionariesEquatable() {
        // Given
        let dictionaries1 = Dictionaries(locations: ["ABC": Location(cityCode: "City1", countryCode: "Country1")], aircraft: ["747": "Boeing 747"], currencies: ["USD": "US Dollar"], carriers: ["AA": "American Airlines"])
        let dictionaries2 = Dictionaries(locations: ["ABC": Location(cityCode: "City1", countryCode: "Country1")], aircraft: ["747": "Boeing 747"], currencies: ["USD": "US Dollar"], carriers: ["AA": "American Airlines"])
        let dictionaries3 = Dictionaries(locations: ["XYZ": Location(cityCode: "City2", countryCode: "Country2")], aircraft: ["320": "Airbus A320"], currencies: ["EUR": "Euro"], carriers: ["BA": "British Airways"])
        
        // Then
        XCTAssertEqual(dictionaries1, dictionaries2)
        XCTAssertNotEqual(dictionaries1, dictionaries3)
    }
    
    func testLocationEquatable() {
        // Given
        let location1 = Location(cityCode: "City1", countryCode: "Country1")
        let location2 = Location(cityCode: "City1", countryCode: "Country1")
        let location3 = Location(cityCode: "City2", countryCode: "Country2")
        
        // Then
        XCTAssertEqual(location1, location2)
        XCTAssertNotEqual(location1, location3)
    }
    
    func testPricingOptionsEquatable() {
        // Given
        let pricingOptions1 = PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false)
        let pricingOptions2 = PricingOptions(fareType: ["PublishedFare"], includedCheckedBagsOnly: false)
        let pricingOptions3 = PricingOptions(fareType: ["NegotiatedFare"], includedCheckedBagsOnly: true)
        
        // Then
        XCTAssertEqual(pricingOptions1, pricingOptions2)
        XCTAssertNotEqual(pricingOptions1, pricingOptions3)
    }
    
    func testTravelerPricingEquatable() {
        // Given
        let travelerPricing1 = TravelerPricing(travelerId: "1", fareOption: "standard", travelerType: "adult", price: TravelerPrice(currency: "USD", total: "100.00", base: "80.00", taxes: nil), fareDetailsBySegment: [])
        let travelerPricing2 = TravelerPricing(travelerId: "1", fareOption: "standard", travelerType: "adult", price: TravelerPrice(currency: "USD", total: "100.00", base: "80.00", taxes: nil), fareDetailsBySegment: [])
        let travelerPricing3 = TravelerPricing(travelerId: "2", fareOption: "premium", travelerType: "child", price: TravelerPrice(currency: "EUR", total: "80.00", base: "60.00", taxes: [Tax(amount: "20.00", code: "TX")]), fareDetailsBySegment: [FareDetailsBySegment(segmentId: "1", cabin: "economy", fareBasis: "ABC123", class: "Y", includedCheckedBags: nil)])
        
        // Then
        XCTAssertEqual(travelerPricing1, travelerPricing2)
        XCTAssertNotEqual(travelerPricing1, travelerPricing3)
    }
    
    func testTravelerPriceEquatable() {
        // Given
        let travelerPrice1 = TravelerPrice(currency: "USD", total: "100.00", base: "80.00", taxes: nil)
        let travelerPrice2 = TravelerPrice(currency: "USD", total: "100.00", base: "80.00", taxes: nil)
        let travelerPrice3 = TravelerPrice(currency: "EUR", total: "90.00", base: "70.00", taxes: [Tax(amount: "20.00", code: "TX")])
        
        // Then
        XCTAssertEqual(travelerPrice1, travelerPrice2)
        XCTAssertNotEqual(travelerPrice1, travelerPrice3)
    }
    
    func testTaxEquatable() {
        // Given
        let tax1 = Tax(amount: "20.00", code: "TX")
        let tax2 = Tax(amount: "20.00", code: "TX")
        let tax3 = Tax(amount: "30.00", code: "FE")
        
        // Then
        XCTAssertEqual(tax1, tax2)
        XCTAssertNotEqual(tax1, tax3)
    }
    
    func testFareDetailsBySegmentEquatable() {
        // Given
        let fareDetailsBySegment1 = FareDetailsBySegment(segmentId: "1", cabin: "economy", fareBasis: "ABC123", class: "Y", includedCheckedBags: nil)
        let fareDetailsBySegment2 = FareDetailsBySegment(segmentId: "1", cabin: "economy", fareBasis: "ABC123", class: "Y", includedCheckedBags: nil)
        let fareDetailsBySegment3 = FareDetailsBySegment(segmentId: "2", cabin: "business", fareBasis: "XYZ456", class: "C", includedCheckedBags: IncludedCheckedBags(quantity: 2, weight: 32, weightUnit: "kg"))
        
        // Then
        XCTAssertEqual(fareDetailsBySegment1, fareDetailsBySegment2)
        XCTAssertNotEqual(fareDetailsBySegment1, fareDetailsBySegment3)
    }
    
    func testIncludedCheckedBagsEquatable() {
        // Given
        let includedCheckedBags1 = IncludedCheckedBags(quantity: 2, weight: 23, weightUnit: "kg")
        let includedCheckedBags2 = IncludedCheckedBags(quantity: 2, weight: 23, weightUnit: "kg")
        let includedCheckedBags3 = IncludedCheckedBags(quantity: 1, weight: 30, weightUnit: "lb")
        
        // Then
        XCTAssertEqual(includedCheckedBags1, includedCheckedBags2)
        XCTAssertNotEqual(includedCheckedBags1, includedCheckedBags3)
    }
    
    func testCO2EmissionEquatable() {
        // Given
        let co2Emission1 = co2Emission(weight: 100, weightUnit: "kg", cabin: "economy")
        let co2Emission2 = co2Emission(weight: 100, weightUnit: "kg", cabin: "economy")
        let co2Emission3 = co2Emission(weight: 150, weightUnit: "lb", cabin: "business")
        
        // Then
        XCTAssertEqual(co2Emission1, co2Emission2)
        XCTAssertNotEqual(co2Emission1, co2Emission3)
    }
}
