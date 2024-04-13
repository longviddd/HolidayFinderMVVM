import SwiftUI

struct MainTabView: View {
    // If needed, you can introduce @State or @EnvironmentObject variables here for app-wide state management.

    var body: some View {
        TabView {
            NavigationView {
                HolidaySearchView() // Your existing Holiday Search View
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            
            NavigationView {
                MyVacationsView()
            }
            .tabItem {
                Image(systemName: "suitcase.fill")
                Text("Vacations")
            }

            NavigationView {
                MyFlightsView()
            }
            .tabItem {
                Image(systemName: "airplane")
                Text("Flights")
            }
        }
        // Modify the TabView's appearance here if needed.
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
