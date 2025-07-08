//
//  WeatherService.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import Foundation

enum WeatherError: Error {
    case invalidCity
    case networkError(URLError)
    case decodingError
    case unknown
}

struct WeatherService {
    static func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
        let apiKey = "fa2967fd77ff9f7308c8232ba88dd8f4"
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(.invalidCity))
            return
        }
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&appid=\(apiKey)&units=metric&lang=tr"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidCity))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let urlError = error as? URLError {
                completion(.failure(.networkError(urlError)))
                return
            }

            guard let data = data else {
                completion(.failure(.unknown))
                return
            }

            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherData))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
