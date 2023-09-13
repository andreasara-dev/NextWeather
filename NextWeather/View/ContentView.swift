//
//  ContentView.swift
//  NextWeather
//
//  Created by andreasara-dev on 03/08/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherManager: WeatherManager
    
    var body: some View {
        TabView {
            Group {
                WeatherView()
                    .tabItem {
                        Label("Weather", systemImage: "cloud.sun")
                    }
                
                MapView(userRegion: $locationManager.userRegion)
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
            }
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(LocationManager())
        .environmentObject(WeatherManager())
        .environmentObject(NetworkManager())
    }
}
