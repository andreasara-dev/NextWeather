//
//  WeatherForecastView.swift
//  NextWeather
//
//  Created by andreasara-dev on 12/09/23.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @AppStorage("isFahrenheit") var isFahrenheitSelected = false
    
    let weather: Forecasts
    
    let vColumns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        LazyVGrid(columns: vColumns, spacing: 20) {
            ForEach(weather.daily.time.indices, id: \.self) { index in
                Text("\(weatherManager.detectTodayDate(for: weather.daily.time[index]))")
                Image(systemName: weather.detectWeatherSymbol(code: weather.daily.weathercode[index]))
                    .font(.title3)
                    .symbolRenderingMode(.multicolor)
                HStack {
                    Image(systemName: "thermometer.low")
                        .symbolRenderingMode(.multicolor)
                    Text("\(weatherManager.temperatureToShow(isFahrenheit: isFahrenheitSelected, temperature: weather.daily.temperature2mMin[index]))")
                }
                HStack {
                    Image(systemName: "thermometer.high")
                        .symbolRenderingMode(.multicolor)
                    Text("\(weatherManager.temperatureToShow(isFahrenheit: isFahrenheitSelected, temperature: weather.daily.temperature2mMax[index]))")
                }
            }
        }
        .padding()
    }
}

struct WeatherForecastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView(weather: Forecasts.example)
    }
}
