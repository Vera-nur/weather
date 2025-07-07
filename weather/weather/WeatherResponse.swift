//
//  WeatherResponse.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let weather: [Weather]
    let main: Main
    let sys: Sys
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

struct Sys: Decodable {
    let country: String
    let sunrise: Int
    let sunset: Int
}
