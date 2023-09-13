//
//  WeatherDetailView.swift
//  NextWeather
//
//  Created by andreasara-dev on 12/09/23.
//

import SwiftUI

struct WeatherDetailView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @AppStorage("isFahrenheit") var isFahrenheitSelected = false
    
    let weather: Forecasts
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(weatherManager.temperatureToShow(isFahrenheit: isFahrenheitSelected, temperature: weather.currentWeather.temperature))
                    .font(.largeTitle)
                Image(systemName: weather.firstCurrentSymbol)
                    .font(.largeTitle)
                    .symbolRenderingMode(.multicolor)
            }
            Group {
                Text(weather.firstCurrentStatus)
                HStack {
                    Text("MAX: \(weatherManager.temperatureToShow(isFahrenheit: isFahrenheitSelected, temperature: weather.daily.temperature2mMax[0]))")
                    Text("MIN: \(weatherManager.temperatureToShow(isFahrenheit: isFahrenheitSelected, temperature: weather.daily.temperature2mMin[0]))")
                }
            }
            .font(.title3)
            .bold()
        }
        
        HStack(spacing: 20) {
            Grid(verticalSpacing: 10) {
                GridRow {
                    Image(systemName: "sunrise.fill")
                        .symbolRenderingMode(.multicolor)
                    Text(weatherManager.dateToString(isoDateString: weather.daily.sunrise.first!))
                }
                
                GridRow {
                    Image(systemName: "sunset.fill")
                        .symbolRenderingMode(.multicolor)
                    Text(weatherManager.dateToString(isoDateString: weather.daily.sunset.first!))
                }
            }
            .padding()
            
            Grid(verticalSpacing: 10) {
                GridRow {
                    Text("Wind Speed")
                    Text("\(Int(weather.currentWeather.windspeed)) km/h")
                }
                
                GridRow {
                    Text("Wind Direction")
                    Text("\(weather.currentWeather.windDirection)°")
                }
            }
        }
    }
}

struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailView(weather: Forecasts.example)
    }
}
