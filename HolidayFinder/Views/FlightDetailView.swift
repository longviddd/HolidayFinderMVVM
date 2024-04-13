//
//  FlightDetailView.swift
//  HolidayFinder
//
//  Created by long on 2024-03-12.
//

import SwiftUI

struct FlightDetailView: View {
    @StateObject private var viewModel: FlightDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(selectedFlightOffer: FlightOffer, isFromMyFlights: Bool = false) {
        _viewModel = StateObject(wrappedValue: FlightDetailViewModel(selectedFlightOffer: selectedFlightOffer))
        self.isFromMyFlights = isFromMyFlights
    }
    
    let isFromMyFlights: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                FlightHeaderView(viewModel: viewModel)
                
                if viewModel.isLoading {
                    LoadingView()
                } else if let flightDetails = viewModel.flightDetails {
                    ForEach(Array(flightDetails.data.flightOffers[0].itineraries.enumerated()), id: \.offset) { index, itinerary in
                        ForEach(Array(itinerary.segments.enumerated()), id: \.offset) { segmentIndex, segment in
                            FlightSegmentView(segment: segment, isReturn: index % 2 != 0, viewModel: viewModel)
                        }
                    }
                }
                
                if !isFromMyFlights {
                    SaveFlightButton(viewModel: viewModel)
                }
                
                Spacer()
            }
        }
        .navigationTitle("Flight Details")
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")) {
                if viewModel.alertMessage == "Flight saved successfully" {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
    }
}

struct FlightHeaderView: View {
    @ObservedObject var viewModel: FlightDetailViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(viewModel.routeTitle)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if !viewModel.validatingCarrier.isEmpty {
                HStack {
                    Image(systemName: "airplane")
                    Text("Validating Carrier: \(viewModel.validatingCarrier)")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            
            HStack {
                Image(systemName: "tag")
                Text("Total Price: EUR \(viewModel.totalPrice)")
                    .font(.title)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
        }
        .padding()
        
        HStack(spacing: 5) {
            Image(systemName: "info.circle")
                .foregroundColor(.gray)
            Text("Real price might be different from the flight lists. Please contact the validating carrier to purchase this offer.")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

struct LoadingView: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Spacer()
        }
    }
}

struct FlightSegmentView: View {
    let segment: Segment
    let isReturn: Bool
    @ObservedObject var viewModel: FlightDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: isReturn ? "airplane.arrival" : "airplane.departure")
                Text("\(segment.departure.iataCode) to \(segment.arrival.iataCode)")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "calendar")
                    Text(viewModel.formatDate(segment.departure.at))
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(viewModel.formatTime(segment.departure.at)) - \(viewModel.formatTime(segment.arrival.at))")
                        .font(.subheadline)
                }
                
                HStack {
                    Image(systemName: "info.circle")
                    Text("\(segment.carrierCode) · \(segment.aircraft.code) · \(viewModel.formatDuration(segment.duration ?? ""))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                if segment.co2Emissions != nil {
                    HStack {
                        Image(systemName: "leaf")
                        Text("CO2 Emissions: \(String(segment.co2Emissions![0].weight)) kg")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.vertical, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct SaveFlightButton: View {
    @ObservedObject var viewModel: FlightDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button(action: {
            viewModel.saveFlightToMyList()
        }) {
            Text("Add to My Flight List")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
}
struct FlightDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let flightOffer = FlightOffer(
            type: "flight-offer",
            id: "1",
            source: "GDS",
            instantTicketingRequired: false,
            nonHomogeneous: false,
            oneWay: nil,
            lastTicketingDate: "2024-03-17",
            lastTicketingDateTime: nil,
            numberOfBookableSeats: nil,
            itineraries: [],
            price: Price(currency: "EUR", total: "1769.13", base: "1184.00", fees: [], grandTotal: "1769.13", billingCurrency: "EUR"),
            pricingOptions: PricingOptions(fareType: ["PUBLISHED"], includedCheckedBagsOnly: true),
            validatingAirlineCodes: ["EK"],
            travelerPricings: []
        )
        
        NavigationView {
            FlightDetailView(selectedFlightOffer: flightOffer)
        }
    }
}
