//
//  WeatherService.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import Foundation
import CoreLocation

enum WeatherError: Error {
    case invalidCity
    case networkError(URLError)
    case decodingError
    case unknown
}

struct WeatherService {
    
    private static func getAPIKey() -> String {
        guard
            let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path),
            let apiKey = dict["API_KEY"] as? String
        else {
            fatalError("API Key not found in Config.plist")
        }

        return apiKey
    }
    
    static func fetchWeatherByCoordinates(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
        let apiKey = getAPIKey()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&lang=tr"

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
    
    static func fetchWeather(for city: String, completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void) {
            
            let apiKey = getAPIKey()

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
