//
//  WeatherViewModel.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import Foundation
import SwiftUI

class WeatherViewModel: ObservableObject {

    @Published var city: String = ""
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var icon: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var feelsLike: String = ""
    @Published var humidity: String = ""
    @Published var maxTemp: String = ""
    @Published var minTemp: String = ""
    @Published var backgroundColor: Color = Color.gray.opacity(0.1)
    
    func fetchWeather() async {
        guard !city.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.showError("Please enter a city name")
            return
        }

        self.prepareForLoading()

        WeatherService.fetchWeather(for: city) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let weatherData):
                    self.updateUI(with: weatherData)
                case .failure(let error):
                    self.handleError(error)
                }
            }
        }
    }

    private func prepareForLoading() {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
    }

    private func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }

    private func updateUI(with data: WeatherResponse) {
        temperature = String(format: "%.1f°C", data.main.temp)
        description = data.weather.first?.description ?? "No description"
        icon = getIconName(for: data.weather.first?.icon ?? "")
        feelsLike = String(format: "Feels like: %.1f°C", data.main.feels_like)
        humidity = "Humidity: \(Int(data.main.humidity))%"
        maxTemp = String(format: "Max: %.1f°C", data.main.temp_max)
        minTemp = String(format: "Min: %.1f°C", data.main.temp_min)
        backgroundColor = getBackgroundColor(for: data.weather.first?.main.lowercased())
    }

    private func handleError(_ error: WeatherError) {
        switch error {
        case .invalidCity:
            showError("Invalid city name.")
        case .networkError(let urlError):
            switch urlError.code {
            case .notConnectedToInternet:
                showError("No internet connection.")
            case .timedOut:
                showError("Request timed out.")
            default:
                showError("Network error: \(urlError.localizedDescription)")
            }
        case .decodingError:
            showError("Failed to decode the weather data.")
        case .unknown:
            showError("An unknown error occurred.")
        }
    }

    private func getIconName(for code: String) -> String {
        switch code {
        case "01d": return "sun.max.fill"
        case "01n": return "moon.fill"
        case "02d": return "cloud.sun.fill"
        case "02n": return "cloud.moon.fill"
        case "03d", "03n": return "cloud.fill"
        case "04d", "04n": return "smoke.fill"
        case "09d", "09n": return "cloud.drizzle.fill"
        case "10d": return "cloud.sun.rain.fill"
        case "10n": return "cloud.moon.rain.fill"
        case "11d", "11n": return "cloud.bolt.rain.fill"
        case "13d", "13n": return "snowflake"
        case "50d", "50n": return "cloud.fog.fill"
        default: return "questionmark.circle.fill"
        }
    }

    private func getBackgroundColor(for condition: String?) -> Color {
        switch condition {
        case "clear":
            return Color.yellow.opacity(0.3)
        case "clouds":
            return Color.gray.opacity(0.2)
        case "rain", "drizzle":
            return Color.blue.opacity(0.3)
        case "snow":
            return Color.white.opacity(0.8)
        default:
            return Color.gray.opacity(0.1)
        }
    }
}
