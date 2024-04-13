import SwiftUI

struct AirportSelectionView: View {
    @StateObject var viewModel = AirportSelectionViewModel()
    
    @State private var searchQuery = ""
    @State private var showMainView = false
    @State private var showingTooltip = false
    @State private var selectedAirportId: UUID?

    var body: some View {
        NavigationView {
            List(viewModel.filteredAirports) { airport in
                ZStack {
                    Rectangle()
                        .foregroundColor(selectedAirportId == airport.id ? .gray.opacity(0.5) : .clear)
                        .cornerRadius(5)
                        .animation(.easeIn, value: selectedAirportId)
                    
                    HStack {
                        Text("\(airport.city), \(airport.country) - \(airport.name)")
                            .padding()
                        Spacer()
                    }
                }
                .onTapGesture {
                    viewModel.saveSelectedAirport(selectedAirport: airport)
                    self.showMainView = true
                }
                .onLongPressGesture(minimumDuration: 0.5, pressing: { isPressing in
                    self.selectedAirportId = isPressing ? airport.id : nil
                }) { }
                .listRowInsets(EdgeInsets())
            }
            .searchable(text: $searchQuery, prompt: "Search Airports")
            .accessibilityIdentifier("SearchAirportsField")
            .onChange(of: searchQuery) { newValue in
                viewModel.searchAirports(with: newValue)
            }
            .navigationTitle("Choose Your Preferred Airport")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingTooltip.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .accessibilityIdentifier("InfoButton")
                    }
                    .foregroundColor(.gray)
                }
            }
            .sheet(isPresented: $showingTooltip) {
                VStack {
                    Text("Tooltip")
                        .font(.title)
                        .padding()
                    Text("If flying internationally, search 'international' in the box.")
                        .padding()
                    Button("Close") {
                        showingTooltip = false
                    }
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showMainView) {
            MainTabView()
            .navigationViewStyle(.stack)
        }
    }
}
