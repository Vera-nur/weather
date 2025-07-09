//
//  WeatherScreen.swift
//  weather
//
//  Created by Vera Nur on 9.07.2025.
//

import SwiftUI

struct WeatherScreen: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            VStack(spacing: 10) {
                Text("Weather App")
                    .font(.title2)
                    .bold()

                TextField("Enter city", text: $viewModel.city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Button("Show Weather") {
                    Task {
                        viewModel.fetchWeather()
                    }
                }
                .foregroundColor(.blue)
            }
            .padding(.top, 20)

            Spacer()

            if viewModel.isLoading {
                ProgressView()
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }

            if !viewModel.temperature.isEmpty {
                VStack(spacing: 10) {
                    HStack {
                        Text(viewModel.city.capitalized)
                            .font(.title2)
                            .bold()
                    }

                    if !viewModel.icon.isEmpty {
                        Image(systemName: viewModel.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.orange)
                    }

                    Text(viewModel.description.capitalized)
                        .font(.headline)

                    Text(viewModel.temperature)
                        .font(.system(size: 32))
                        .bold()

                    Text(viewModel.feelsLike)
                        .font(.subheadline)

                    Text(viewModel.humidity)
                        .font(.subheadline)

                    Text(viewModel.maxTemp)
                        .font(.subheadline)

                    Text(viewModel.minTemp)
                        .font(.subheadline)
                }
                .padding()
                .background(viewModel.backgroundColor)
                .cornerRadius(20)
                .frame(minWidth: 400, minHeight: 400)
                .padding(.horizontal, 30)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.getWeatherForCurrentLocation()
        }
    }
}

#Preview {
    WeatherScreen()
}
