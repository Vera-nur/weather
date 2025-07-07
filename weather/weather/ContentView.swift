//
//  ContentView.swift
//  weather
//
//  Created by Vera Nur on 7.07.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("Test")
                .onAppear{
                    Task{
                        await testWeatherAPI()
                    }
                }
        }
    }
    
    func testWeatherAPI() async {
            do {
                let weather = try await WeatherService.fetchWeather(for: "İstanbul")
                print("✅ Şehir: \(weather.name)")
                print("🌡️ Sıcaklık: \(weather.main.temp)°C")
                print("📝 Açıklama: \(weather.weather.first?.description ?? "-")")
            } catch {
                print("❌ Hata oluştu: \(error.localizedDescription)")
            }
        }
}

#Preview {
    ContentView()
}
