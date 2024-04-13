//
//  MyFlightsView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-16.
//

import SwiftUI

struct MyFlightsView: View {
    @StateObject private var viewModel: MyFlightsViewModel
    @State private var showingDeleteAlert = false
    @State private var flightIndexToDelete: Int?
    init(isTesting: Bool = false) {
        _viewModel = StateObject(wrappedValue: MyFlightsViewModel(isTesting: isTesting))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                    Text("Price may have changed since you last saved the flights. Press on a specific flight to check.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.savedFlights.indices, id: \.self) { index in
                        let flight = viewModel.savedFlights[index]
                        let _ = print(flight)
                        NavigationLink(destination: FlightDetailView(selectedFlightOffer: flight.data.flightOffers[0], isFromMyFlights: true)) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                let firstOutboundSegment = flight.data.flightOffers[0].itineraries[0].segments[0]
                                let lastOutboundSegment = flight.data.flightOffers[0].itineraries[0].segments.last!
                                let firstReturnSegment = flight.data.flightOffers[0].itineraries[1].segments[0]
                                let lastReturnSegment = flight.data.flightOffers[0].itineraries[1].segments.last!
                                
                                HStack {
                                    Image(systemName: "airplane.departure")
                                    Text("\(firstOutboundSegment.departure.iataCode) -> \(lastOutboundSegment.arrival.iataCode)")
                                }
                                
                                HStack {
                                    Image(systemName: "airplane.arrival")
                                    Text("\(firstReturnSegment.departure.iataCode) -> \(lastReturnSegment.arrival.iataCode)")
                                }
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("Start: \(viewModel.formatDate(firstOutboundSegment.departure.at))")
                                }
                                
                                HStack {
                                    Image(systemName: "calendar")
                                    Text("End: \(viewModel.formatDate(lastReturnSegment.arrival.at))")
                                }
                                
                                HStack {
                                    Image(systemName: "tag")
                                    Text("\(flight.data.flightOffers[0].price.total) \(flight.data.flightOffers[0].price.currency)")
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                flightIndexToDelete = index
                                showingDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Delete Flight"),
                    message: Text("Are you sure you want to delete this flight?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = flightIndexToDelete {
                            viewModel.deleteFlight(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .navigationTitle("My Flights")
        }
    }
}

struct MyFlightsView_Previews: PreviewProvider {
    static var previews: some View {
        MyFlightsView()
    }
}
