//
//  WeatherViewModel.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import Foundation

class WeatherViewModel: ObservableObject{
    @Published var city: String = ""
    @Published var temperature: String = ""
    @Published var description: String = ""
    @Published var icon: String = ""
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    func fetchWeather() async {
        guard !city.isEmpty else {
            errorMessage = "Please enter a city name"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let weatherData = try await WeatherService.fetchWeather(for: city)
            self.temperature = String(format: "%.1f°C", weatherData.main.temp)
            self.description = weatherData.weather[0].description
        } catch let urlError as URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                errorMessage = "No internet connection. Please check your network."
            case .timedOut:
                errorMessage = "The request timed out. Please try again."
            case .cannotFindHost, .cannotConnectToHost:
                errorMessage = "Cannot connect to server. Please try again later."
            default:
                errorMessage = "Network error: \(urlError.localizedDescription)"
            }
        } catch let decodingError as DecodingError {
            errorMessage = "Data decoding failed. Please try again later."
            print("Decoding Error: \(decodingError)")
        } catch {
            errorMessage = "Could not find the city. Please check the name and try again."
        }
        
        isLoading = false
    }
}
