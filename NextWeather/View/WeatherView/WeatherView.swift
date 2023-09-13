//
//  WeatherView.swift
//  NextWeather
//
//  Created by andreasara-dev on 03/08/23.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var weatherManager: WeatherManager
    @EnvironmentObject var networkManager: NetworkManager
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var searchLocation = ""
    
    var body: some View {
        if networkManager.isConnected {
            ZStack {
                if colorScheme == .light {
                    LinearGradient(colors: [.cyan, .blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    VStack {
                        HStack {
                            TextField("Search location", text: $searchLocation)
                                .textFieldStyle(.roundedBorder)
                            Button {
                                locationManager.detectCoordinates(from: searchLocation) { location in
                                    if let locationCoordinates = location {
                                        locationManager.detectCityName(from: locationCoordinates)
                                        weatherManager.fetchWeatherForecasts(coordinates: locationCoordinates)
                                    } else {
                                        return
                                    }
                                }
                                searchLocation = ""
                            } label: {
                                Image(systemName: "magnifyingglass")
                            }
                            .foregroundColor(colorScheme == .light ? .white : .none)
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        VStack {
                            Text(locationManager.locationName ?? "Unknown")
                                .font(.title)
                                .padding(.top)
                            if let weather = weatherManager.forecasts {
                                Group {
                                    WeatherDetailView(weather: weather)
                                    
                                    WeatherForecastView(weather: weather)
                                    
                                    HourlyForecastView(weather: weather)
                                }
                            } else {
                                ProgressView()
                            }
                        }
                        .multilineTextAlignment(.center)
                        .task {
                            locationManager.didUpdateLocations = { locations in
                                if let location = locations.first {
                                    weatherManager.fetchWeatherForecasts(coordinates: location.coordinate)
                                    locationManager.detectCityName(from: location.coordinate)
                                }
                            }
                            locationManager.requestLocation()
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
        } else {
            NoConnectionView()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherView()
            WeatherView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(LocationManager())
        .environmentObject(WeatherManager())
        .environmentObject(NetworkManager())
    }
}
