//
//  NetworkService.swift
//  HolidayFinder
//
//  Created by long on 2024-02-11.
//

import Foundation

class NetworkService {
    static let shared = NetworkService() // Singleton instance
    
    private let airportsURL = URL(string: "https://raw.githubusercontent.com/mwgg/Airports/master/airports.json")!
    private let availableCountriesURL = URL(string: "https://date.nager.at/api/v3/AvailableCountries")!
    private let authURL = URL(string: "https://api.amadeus.com/v1/security/oauth2/token")!
    private let flightOffersURL = URL(string: "https://api.amadeus.com/v2/shopping/flight-offers")!
    public init() {}

    func fetchAirports(completion: @escaping ([Airport]?) -> Void) {
        URLSession.shared.dataTask(with: airportsURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching airports: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let airportsDict = try decoder.decode([String: Airport].self, from: data)
                let airportsWithIATA = airportsDict.filter { $0.value.iata != "N/A" && !$0.value.iata.isEmpty &&  !$0.value.city.isEmpty}.map { $0.value }
                DispatchQueue.main.async {
                    completion(airportsWithIATA)
                }
            } catch {
                print("Error decoding airports: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    func fetchAvailableCountries(completion: @escaping ([Country]?) -> Void) {
        URLSession.shared.dataTask(with: availableCountriesURL) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching available countries: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }

            let decoder = JSONDecoder()
            do {
                let countries = try decoder.decode([Country].self, from: data)
                DispatchQueue.main.async {
                    completion(countries)
                }
            } catch {
                print("Error decoding available countries: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    func fetchHolidays(forCountry countryCode: String, year: String, completion: @escaping ([Holiday]?) -> Void) {
        let urlString = "https://date.nager.at/api/v3/PublicHolidays/\(year)/\(countryCode)"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching holidays: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let holidays = try decoder.decode([Holiday].self, from: data)
                DispatchQueue.main.async {
                    completion(holidays)
                }
            } catch {
                print("Error decoding holidays: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    func fetchAuthToken(completion: @escaping (Result<String, Error>) -> Void) {
        let body = "grant_type=client_credentials&client_id=jUIvwPZ7ksDuC4IKGcNioT6ODeyjfRwz&client_secret=pQ6CG6lN0wk4Nkpk"
        
        var request = URLRequest(url: authURL)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let accessToken = json["access_token"] as? String {
                completion(.success(accessToken))
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
            }
        }.resume()
    }
    
    func fetchFlights(originAirport: String, destinationAirport: String, departureDate: String, returnDate: String, adults: Int, authToken: String, completion: @escaping (Result<FlightResponse?, Error>) -> Void) {
        let urlString = "\(flightOffersURL)?originLocationCode=\(originAirport)&destinationLocationCode=\(destinationAirport)&departureDate=\(departureDate)&returnDate=\(returnDate)&adults=\(adults)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   json["data"] != nil {
                    let flightResponse = try JSONDecoder().decode(FlightResponse.self, from: data)
                    completion(.success(flightResponse))
                } else {
                    completion(.success(nil))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    func fetchFlightDetails(selectedFlightOffer: FlightOffer, token: String, completion: @escaping (Result<FlightResponsePrice?, Error>) -> Void) {
        let url = URL(string: "https://api.amadeus.com/v1/shopping/flight-offers/pricing")!
        
        let priceFlightOffersBody: [String: Any] = [
            "data": [
                "type": "flight-offers-pricing",
                "flightOffers": [
                    [
                        "type": selectedFlightOffer.type,
                        "id": selectedFlightOffer.id,
                        "source": selectedFlightOffer.source,
                        "instantTicketingRequired": selectedFlightOffer.instantTicketingRequired,
                        "nonHomogeneous": selectedFlightOffer.nonHomogeneous,
                        "oneWay": selectedFlightOffer.oneWay,
                        "lastTicketingDate": selectedFlightOffer.lastTicketingDate,
                        "numberOfBookableSeats": selectedFlightOffer.numberOfBookableSeats,
                        "itineraries": selectedFlightOffer.itineraries.map { $0.toDictionary() },
                        "price": selectedFlightOffer.price.toDictionary(),
                        "pricingOptions": selectedFlightOffer.pricingOptions.toDictionary(),
                        "validatingAirlineCodes": selectedFlightOffer.validatingAirlineCodes,
                        "travelerPricings": selectedFlightOffer.travelerPricings.map { $0.toDictionary() }
                    ]
                ]
            ]
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONSerialization.data(withJSONObject: priceFlightOffersBody, options: [])
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Request Body:")
            print(bodyString)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   json["data"] != nil {
                    let flightResponse = try JSONDecoder().decode(FlightResponsePrice.self, from: data)
                    completion(.success(flightResponse))
                } else {
                    print(try! JSONSerialization.jsonObject(with: data, options: []))
                    completion(.success(nil))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}
