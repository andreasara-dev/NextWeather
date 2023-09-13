//
//  NextWeatherApp.swift
//  NextWeather
//
//  Created by andreasara-dev on 03/08/23.
//

import SwiftUI

@main
struct NextWeatherApp: App {
    @StateObject var locationManager = LocationManager()
    @StateObject var weatherManager = WeatherManager()
    @StateObject var networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(weatherManager)
                .environmentObject(networkManager)
        }
    }
}
