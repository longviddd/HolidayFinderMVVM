//
//  MyVacationsViewModel.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import Foundation

class MyVacationsViewModel: ObservableObject {
    @Published var vacations: [VacationDetails] = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    init(vacations: [VacationDetails] = []) {
        self.vacations = vacations
    }

    func loadVacations() {
        if vacations.isEmpty {
            if let data = UserDefaults.standard.data(forKey: "vacationList"),
               let vacationList = try? JSONDecoder().decode([VacationDetails].self, from: data) {
                vacations = vacationList
            }
        }
    }

    func deleteVacation(vacation: VacationDetails?) {
        guard let vacation = vacation else { return }
        if let index = vacations.firstIndex(where: { $0 == vacation }) {
            vacations.remove(at: index)
            saveVacations()
        }
    }

    private func saveVacations() {
        if let encodedData = try? JSONEncoder().encode(vacations) {
            UserDefaults.standard.set(encodedData, forKey: "vacationList")
        }
    }
}
