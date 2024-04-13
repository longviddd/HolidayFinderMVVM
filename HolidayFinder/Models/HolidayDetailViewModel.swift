//
//  HolidayDetailViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-03.
//

import Foundation

class HolidayDetailViewModel: ObservableObject {
    @Published var holiday: Holiday
    
    init(holiday: Holiday) {
        self.holiday = holiday
    }

    func getDayOfWeek(date: String) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else { return nil }
        formatter.dateFormat = "EEEE" // Day name format
        return formatter.string(from: date)
    }
}

