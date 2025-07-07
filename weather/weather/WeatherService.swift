//
//  WeatherService.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import Foundation

struct WeatherService {
    // completion -> IOS 10+,
    //async/await -> IOS 15+ daha temiz ve okunabilir,
    //Combine -> IOS 13+,
    //delegate, NotificationCenter hangi yapıyı kullanmak daha sağlıklı?
    
    static func fetchWeather(for city: String) async throws -> WeatherResponse {
        let apiKey = "fa2967fd77ff9f7308c8232ba88dd8f4"
        
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityEncoded)&appid=\(apiKey)&units=metric&lang=tr"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return decodedData
    }
}
