//
//  Forecasts.swift
//  NextWeather
//
//  Created by andreasara-dev on 06/08/23.
//

import Foundation

struct Forecasts: Decodable {
    let latitude: Double
    let longitude: Double
    let hourlyUnits: HourlyUnits
    let hourly: Hourly
    let currentWeather: CurrentWeather
    let daily: Daily
    
    private enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case hourlyUnits = "hourly_units"
        case hourly
        case currentWeather = "current_weather"
        case daily
    }
    
    static let example = Forecasts(latitude: 52.52, longitude: 13.41, hourlyUnits: HourlyUnits(temperature2m: "°C"), hourly: Hourly(time: ["2022-07-01T00:00","2022-07-01T01:00"], temperature2m: [13.7,13.3,12.8,12.3], weathercode: []), currentWeather: CurrentWeather(time: "2022-07-01T09:00", temperature: 13.4, weatherCode: 3, windspeed: 10.3, windDirection: 262, isDay: 1), daily: Daily(time: [], temperature2mMax: [], temperature2mMin: [], weathercode: [], sunrise: [], sunset: []))
}

struct HourlyUnits: Decodable {
    let temperature2m: String
    
    private enum CodingKeys: String, CodingKey {
        case temperature2m = "temperature_2m"
    }
}

struct Hourly: Decodable {
    let time: [String]
    let temperature2m: [Double]
    let weathercode: [Int]
    
    private enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case weathercode
    }
}

struct CurrentWeather: Decodable {
    let time: String
    let temperature: Double
    let weatherCode: Int
    let windspeed: Double
    let windDirection: Int
    let isDay: Int
    
    private enum CodingKeys: String, CodingKey {
        case time
        case temperature
        case weatherCode = "weathercode"
        case windspeed
        case windDirection = "winddirection"
        case isDay = "is_day"
    }
}

struct Daily: Decodable {
    let time: [String]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let weathercode: [Int]
    let sunrise: [String]
    let sunset: [String]
    
    private enum CodingKeys: String, CodingKey {
        case time
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case weathercode
        case sunrise
        case sunset
    }
}

extension Forecasts {
    func detectWeatherSymbolAndStatus(code: Int, isDay: Int? = nil) -> (status: String, symbol: String) {
        switch code {
        case 0, 1:
            if let isDay = isDay {
                return isDay == 1 ? ("Cielo limpido e soleggiato", "sun.max.fill") : ("Cielo limpido", "moon.fill")
            } else {
                return ("Cielo limpido e soleggiato", "sun.max.fill")
            }
        case 2:
            if let isDay = isDay {
                return isDay == 1 ? ("Coperto", "cloud.sun.fill") : ("Coperto", "cloud.moon.fill")
            } else {
                return ("Coperto", "cloud.sun.fill")
            }
        case 3:
            return ("Nuvoloso", "cloud.fill")
        case 45, 48:
            return ("Nebbia", "cloud.fog.fill")
        case 51, 53, 55, 56, 57:
            return ("Pioggiarella", "cloud.drizzle.fill")
        case 61, 63, 66, 80, 81, 82:
            return ("Pioggia", "cloud.rain.fill")
        case 65, 67:
            return ("Pioggia torrenziale", "cloud.heavyrain.fill")
        case 71, 73, 75, 77, 85, 86:
            return ("Neve", "cloud.snow.fill")
        case 95:
            return ("Temporale", "cloud.bolt.rain.fill")
        case 96, 99:
            return ("Grandine", "cloud.hail.fill")
        default:
            return ("Nuvoloso", "cloud.fill")
        }
    }
    
    var firstCurrentSymbol: String {
        let (_, symbol) = self.detectWeatherSymbolAndStatus(code: daily.weathercode.first ?? 1, isDay: currentWeather.isDay)
        return symbol
    }
    
    var firstCurrentStatus: String {
        let (status, _) = self.detectWeatherSymbolAndStatus(code: daily.weathercode.first ?? 1, isDay: currentWeather.isDay)
        return status
    }
    
    func detectWeatherSymbol(code: Int) -> String {
        let (_, symbol) = self.detectWeatherSymbolAndStatus(code: code)
        return symbol
    }
}
