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
                let airportsWithIATA = airportsDict.filter { $0.value.iata != "N/A" }.map { $0.value }
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

}
