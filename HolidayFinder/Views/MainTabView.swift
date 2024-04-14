import SwiftUI

struct MainTabView: View {
  

    var body: some View {
        TabView {
            NavigationView {
                HolidaySearchView()
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
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
