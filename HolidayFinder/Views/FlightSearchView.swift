//
//  FlightSearchView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-09.
//

import SwiftUI
struct FlightSearchView: View {
    let vacation: VacationDetails
    @StateObject private var viewModel: FlightSearchViewModel
    @State private var visibleFlights = 5
    @State private var selectedFlightOffer: FlightOffer?
    
    
    init(vacation: VacationDetails) {
        self.vacation = vacation
        _viewModel = StateObject(wrappedValue: FlightSearchViewModel(vacation: vacation))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("All flights from \(vacation.originAirport) to \(vacation.destinationAirport)")
                    .font(.title)
                    .padding(.bottom)
                
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                } else if viewModel.fetchError {
                    Text("An error occurred. Please try again.")
                    Button("Try Again") {
                        viewModel.searchFlights()
                    }
                } else if viewModel.noFlightsFound {
                    Text("No flights found. Try changing the airports or try again.")
                    Button("Try Again") {
                        viewModel.searchFlights()
                    }
                } else {
                    HStack {
                        Button(action: {
                            viewModel.sortByTotalDuration()
                        }) {
                            Text("Sort by Duration")
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.sortByPrice()
                        }) {
                            Text("Sort by Price")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.bottom)
                    
                    ForEach(viewModel.flights.prefix(visibleFlights)) { flight in
                        if let selectedFlightOffer = selectedFlightOffer {
                            NavigationLink(
                                destination: FlightDetailView(selectedFlightOffer: selectedFlightOffer),
                                tag: selectedFlightOffer,
                                selection: $selectedFlightOffer,
                                label: {
                                    VStack(alignment: .leading, spacing: 10) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Outbound")
                                                    .font(.headline)
                                                    
                                                Text("\(flight.outboundOriginAirport) -> \(flight.outboundDestinationAirport)")
                                                Text("Duration: \(flight.outboundDuration)")
                                            }
                                            
                                            Spacer()
                                            
                                            Text("\(flight.price, specifier: "%.2f") EUR")
                                                .font(.title2)
                                                .foregroundColor(.green)
                                        }
                                        
                                        HStack {
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text("Return")
                                                    .font(.headline)
                                                Text("\(flight.returnOriginAirport) -> \(flight.returnDestinationAirport)")
                                                Text("Duration: \(flight.returnDuration)")
                                            }
                                            
                                            Spacer()
                                        }
                                        
                                        Divider()
                                    }

                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                                }
                            )
                        } else {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Outbound")
                                            .font(.headline)
                                        Text("\(flight.outboundOriginAirport) -> \(flight.outboundDestinationAirport)")
                                        Text("Duration: \(flight.outboundDuration)")
                                            .accessibilityIdentifier("OutboundDuration")
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(flight.price, specifier: "%.2f") EUR")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                        .accessibilityIdentifier("FlightInstance")
                                }
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Return")
                                            .font(.headline)
                                        Text("\(flight.returnOriginAirport) -> \(flight.returnDestinationAirport)")
                                        Text("Duration: \(flight.returnDuration)")
                                            .accessibilityIdentifier("ReturnDuration")
                                    }
                                    
                                    Spacer()
                                }
                                
                                Divider()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
                            .onTapGesture {
                                selectedFlightOffer = viewModel.findFlightOffer(for: flight)
                            }
                            
                        }
                        
                    }
                    
                    if visibleFlights < viewModel.flights.count {
                        Button("Show More") {
                            visibleFlights += 5
                        }
                        .padding()
                    }
                }
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Flight Search")
        .onAppear {
            if CommandLine.arguments.contains("testingFlightSearch") {
                
            }
            else{
                viewModel.searchFlights()
            }
            
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
}

struct FlightSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FlightSearchView(vacation: VacationDetails(
                originAirport: "LAX",
                destinationAirport: "JFK",
                startDate: Date(),
                endDate: Date().addingTimeInterval(3600 * 24 * 7)
            ))
        }
    }
}
