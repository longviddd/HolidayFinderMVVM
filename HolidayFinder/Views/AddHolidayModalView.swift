//
//  AddHolidayModalView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-04.
//

import SwiftUI

struct AddHolidayModalView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = AddHolidayModalViewModel()
    @State private var showingOriginAirportSelection = false
    @State private var showingDestinationAirportSelection = false
    init(defaultOriginAirport: String? = UserDefaults.standard.string(forKey: "selectedAirport"), initialStartDate: Date? = nil) {
        _viewModel = StateObject(wrappedValue: AddHolidayModalViewModel(defaultOriginAirport: defaultOriginAirport, initialStartDate: initialStartDate))
    }

    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .navigationTitle("Select Airport")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
            }
            else{
                
                
                Form {
                    if viewModel.currentStep < 3{
                        Section(header: Text("Airport Selection")) {
                            if viewModel.currentStep == 1 {
                                Button("Select Origin Airport: \(viewModel.originAirport)") {
                                    showingOriginAirportSelection = true
                                }
                            } else if viewModel.currentStep == 2 {
                                Button("Select Destination Airport: \(viewModel.destinationAirport)") {
                                    showingDestinationAirportSelection = true
                                }
                            }
                        }
                        
                    }
                    
                    if viewModel.currentStep == 3 {
                        Section(header: Text("Departure Date")) {
                            DatePicker("Select Departure Date", selection: $viewModel.startDate, displayedComponents: .date)
                                .accessibilityIdentifier("DatePicker1")
                                .datePickerStyle(.compact)
                        }
                    } else if viewModel.currentStep == 4 {
                        Section(header: Text("Return Date")) {
                            DatePicker("Select Return Date", selection: $viewModel.endDate, displayedComponents: .date)
                                .accessibilityIdentifier("DatePicker2")
                                .datePickerStyle(.compact)
                        }
                    }
                    
                    
                    Section {
                        if viewModel.currentStep < 4 {
                            Button("Next") {
                                viewModel.nextStep()
                            }
                            .disabled(!viewModel.isNextButtonEnabled)
                        } else {
                            Button("Save Vacation") {
                                viewModel.saveVacation()
                                presentationMode.wrappedValue.dismiss()
                            }
                            .disabled(!viewModel.isNextButtonEnabled)
                        }
                    }
                }
                .navigationTitle("Add Holiday")
                .navigationBarItems(leading: Button("Back") {
                    viewModel.previousStep()
                }, trailing: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
                .sheet(isPresented: $showingOriginAirportSelection) {
                    AirportSelectionSheetView(isForOrigin: true, viewModel: viewModel)
                }
                .sheet(isPresented: $showingDestinationAirportSelection) {
                    AirportSelectionSheetView(isForOrigin: false, viewModel: viewModel)
                }
            }
        }
    }
}

struct AirportSelectionSheetView: View {
    var isForOrigin: Bool
    @ObservedObject var viewModel: AddHolidayModalViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(viewModel.filteredAirports, id: \.self) { airport in
                Button(action: {
                
                    if isForOrigin {
                        viewModel.selectOriginAirport(airport)
                    } else {////
                        viewModel.selectDestinationAirport(airport)
                    }
                    self.presentationMode.wrappedValue.dismiss() // Dismiss the view
                }) {
                    Text("\(airport.name) (\(airport.iata))")
                }
            }
            .searchable(text: $viewModel.searchQuery)
            .navigationBarTitle("Select Airport", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}




struct AddHolidayModalView_Previews: PreviewProvider {
    static var previews: some View {
        AddHolidayModalView()
    }
}
