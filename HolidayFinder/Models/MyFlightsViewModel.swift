//
//  MyFlightsViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import Foundation
import Combine

class MyFlightsViewModel: ObservableObject {
    @Published var savedFlights: [FlightResponsePrice] = []
    @Published var isLoading = false
    
    var isTesting = false
    
    init(isTesting: Bool = false) {
            loadSavedFlights()
    }
    
    func loadSavedFlights() {
        isLoading = true
        if let savedFlightsData = UserDefaults.standard.data(forKey: "myFlights"),
           let savedFlights = try? JSONDecoder().decode([FlightResponsePrice].self, from: savedFlightsData) {
            self.savedFlights = savedFlights
        }
        isLoading = false
    }
    

    
    func deleteFlight(at index: Int) {
        savedFlights.remove(at: index)
        if !isTesting {
            saveFlights()
        }
    }
    
    private func saveFlights() {
        if let encodedData = try? JSONEncoder().encode(savedFlights) {
            UserDefaults.standard.set(encodedData, forKey: "myFlights")
        }
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: date)
    }
}
