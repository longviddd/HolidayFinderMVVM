//
//  MyVacationsView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import SwiftUI

struct MyVacationsView: View {
    @StateObject private var viewModel: MyVacationsViewModel
    @State private var showingDeleteAlert = false
    @State private var vacationToDelete: VacationDetails?
    @Environment(\.scenePhase) private var scenePhase

    // Add a new initializer that accepts a MyVacationsViewModel instance
    init(viewModel: MyVacationsViewModel = MyVacationsViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.vacations, id: \.self) { vacation in
                    NavigationLink(destination: FlightSearchView(vacation: vacation)) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "airplane")
                                Text("\(vacation.originAirport) to \(vacation.destinationAirport)")
                            }
                            HStack {
                                Image(systemName: "calendar")
                                Text("\(vacation.startDate, formatter: viewModel.dateFormatter) - \(vacation.endDate, formatter: viewModel.dateFormatter)")
                            }
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vacationToDelete = vacation
                            showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Vacation"),
                    message: Text("Are you sure you want to delete this vacation?"),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteVacation(vacation: vacationToDelete)
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("My Vacations")
        }
        .onAppear {
            viewModel.loadVacations()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.loadVacations()
            }
        }
    }
}
struct MyVacationsView_Previews: PreviewProvider {
    static var previews: some View {
        MyVacationsView()
    }
}
