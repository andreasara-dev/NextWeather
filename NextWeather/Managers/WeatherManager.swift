//
//  WeatherManager.swift
//  NextWeather
//
//  Created by andreasara-dev on 11/08/23.
//

import Combine
import CoreLocation
import Foundation

final class WeatherManager: ObservableObject {
    @Published var forecasts: Forecasts?
    @Published var requests = Set<AnyCancellable>()
    
    func fetchWeatherForecasts(coordinates: CLLocationCoordinate2D) {
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(coordinates.latitude)&longitude=\(coordinates.longitude)&hourly=temperature_2m,weathercode&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset&current_weather=true&timezone=auto") else {
            fatalError("Failed to connect")
        }
        
        fetch(url, defaultValue: Forecasts.example) { weatherData in
            self.forecasts = weatherData
        }
    }
}

extension WeatherManager {
    private func fetch<T: Decodable, S: Scheduler>(_ url: URL, defaultValue: T, strategy: JSONDecoder.DateDecodingStrategy = .iso8601, receiver: S = DispatchQueue.main, completion: @escaping (T) -> Void) {
        let decoder = JSONDecoder()
        
        URLSession.shared.dataTaskPublisher(for: url)
            .retry(1)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .catch { error -> Just<T> in
                print("Error fetching weather forecasts:", error.localizedDescription)
                return Just(defaultValue)
            }
            .replaceError(with: defaultValue)
            .receive(on: receiver)
            .sink(receiveValue: completion)
            .store(in: &requests)
    }
}

extension WeatherManager {
    private func celsiusToFahreneit(celsius: Double) -> Int {
        let fahrenheit = (celsius * 1.8) + 32
        return Int(fahrenheit)
    }
    
    func temperatureToShow(isFahrenheit: Bool, temperature: Double) -> String {
        if isFahrenheit {
            let fahrenheitTemperature = celsiusToFahreneit(celsius: temperature)
            return "\(Int(fahrenheitTemperature))°"
        } else {
            return "\(Int(temperature))°"
        }
    }
    
    func dateToString(isoDateString: String, dateFormatter: DateFormatter = DateFormatter()) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: isoDateString) {
            dateFormatter.dateFormat = "HH:mm"
            let formattedTimeString = dateFormatter.string(from: date)
            return formattedTimeString
        }
        return ""
    }
    
    func detectTodayDate(for dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                // Display "today"
                return "Today"
            } else {
                dateFormatter.dateFormat = "dd"
                // Display day number
                return dateFormatter.string(from: date)
            }
        } else {
            return "Invalid date"
        }
    }
    
    func next24Hours(from dates: [String]) -> [Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let nextDay = calendar.date(byAdding: .day, value: 1, to: now)!
        let endHour = calendar.component(.hour, from: nextDay)
        
        var result: [Int] = []
        
        for dateString in dates {
            guard let date = dateFormatter.date(from: dateString) else { continue }
            if date < now { continue }
            let hour = calendar.component(.hour, from: date)
            if hour >= currentHour || hour < endHour {
                result.append(hour)
            }
            if result.count == 24 {
                break
            }
        }
        
        return result
    }
    
    var next24Hours: [Int] {
        next24Hours(from: forecasts?.hourly.time ?? [])
    }
    
    func next24AverageTemperatures(from temperatures: [Double]) -> [Double] {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let nextDay = calendar.date(byAdding: .day, value: 1, to: now)!
        let endHour = calendar.component(.hour, from: nextDay)
        
        var result: [Double] = []
        
        for (index, temperature) in temperatures.enumerated() {
            let hour = (currentHour + index) % 24
            if hour >= currentHour || hour < endHour {
                result.append(temperature)
            }
            if result.count == 24 {
                break
            }
        }
        
        return result
    }
    
    var next24Temperatures: [Double] {
        next24AverageTemperatures(from: forecasts?.hourly.temperature2m ?? [])
    }
    
    func next24Weathercodes(from weathercodes: [Int]) -> [Int] {
        let calendar = Calendar.current
        let now = Date()
        let currentHour = calendar.component(.hour, from: now)
        let nextDay = calendar.date(byAdding: .day, value: 1, to: now)!
        let endHour = calendar.component(.hour, from: nextDay)
        
        var result: [Int] = []
        
        for (index, weathercode) in weathercodes.enumerated() {
            let hour = (currentHour + index) % 24
            if hour >= currentHour || hour < endHour {
                result.append(weathercode)
            }
            if result.count == 24 {
                break
            }
        }
        
        return result
    }
    
    var next24Weathercodes: [Int] {
        next24Weathercodes(from: forecasts?.hourly.weathercode ?? [])
    }
}
