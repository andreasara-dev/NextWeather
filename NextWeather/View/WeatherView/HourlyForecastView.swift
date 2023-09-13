//
//  HourlyForecastView.swift
//  NextWeather
//
//  Created by andreasara-dev on 12/09/23.
//

import SwiftUI

struct HourlyForecastView: View {
    @EnvironmentObject var weatherManager: WeatherManager
    @AppStorage("isFahrenheit") var isFahrenheitSelected = false

    let weather: Forecasts
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 30) {
                ForEach(weatherManager.next24Hours.indices, id: \.self) { index in
                    VStack(spacing: 15) {
                        Text("\(weatherManager.next24Hours[index])")
                        Image(systemName: weather.detectWeatherSymbol(code: weatherManager.next24Weathercodes[index]))
                            .symbolRenderingMode(.multicolor)
                        Text("\(weatherManager.temperatureToShow(isFahrenheit: isFahrenheitSelected, temperature: weatherManager.next24Temperatures[index]))")
                    }
                }
            }
        }
        .padding()
    }
}


struct HourlyForecastView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyForecastView(weather: Forecasts.example)
    }
}
