//
//  WeatherView.swift
//  Weather
//
//  Created by Mani on 12/09/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $viewModel.city, onCommit: {
                Task {
                    await viewModel.fetchWeather()
                }
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !viewModel.temperature.isEmpty {
                Text("Temperature: \(viewModel.temperature)")
                    .font(.title2)
                    .padding()
                
                if let iconImage = viewModel.iconImage {
                    Image(uiImage: iconImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()
                }
            }
            
            if !viewModel.description.isEmpty {
                Text("Status: \(viewModel.description)")
                    .font(.title2)
            }
            
            Spacer()
        }
        .padding()
    }
}
