//
//  WeatherComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 1/16/25.
//

import SwiftUI
import WeatherKit
import CoreLocation

extension WeatherCondition {
    
    /// Gets SFSymbols name to represent each possible weather condition
    func getIconName() -> String {
        
        switch self {
        case .blizzard, .flurries, .snow, .heavySnow, .wintryMix:
            return "cloud.snow.fill"
        case .blowingSnow:
            return "wind.snow"
        case .windy, .breezy:
            return "wind"
        case .clear, .hot:
            return "sun.max.fill"
        case .mostlyClear, .partlyCloudy, .mostlyCloudy:
            return "cloud.sun.fill"
        case .cloudy:
            return "cloud.fill"
        case .foggy:
            return "cloud.fog.fill"
        case .drizzle:
            return "cloud.drizzle.fill"
        case .rain:
            return "cloud.rain.fill"
        case .heavyRain:
            return "cloud.heavyrain.fill"
        case .hail:
            return "cloud.hail.fill"
        case .sleet:
            return "cloud.sleet.fill"
        case .sunShowers:
            return "cloud.sun.rain.fill"
        case .thunderstorms, .strongStorms:
            return "cloud.bolt.rain.fill"
        case .scatteredThunderstorms, .isolatedThunderstorms:
            return "cloud.sun.bolt.fill"
        case .haze:
            return "sun.haze.fill"
        case .smoky:
            return "smoke.fill"
        case .freezingDrizzle, .freezingRain, .frigid:
            return "snowflake"
        case .hurricane:
            return "hurricane"
        case .tropicalStorm:
            return "tropicalstorm"
        case .sunFlurries:
            return "sun.snow"
        default:
            return "cloud"
        }
    }
}

/// Format for important components of daily weather returned from WeatherKit
struct WeatherData: Identifiable {
    
    let id = UUID()
    let date: Date
    let high: Measurement<UnitTemperature>
    let low: Measurement<UnitTemperature>
    let condition: WeatherCondition
    
}

struct WeatherComponent: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var errorText: String = ""
    @State var weatherData: [WeatherData] = []
    @State var attImage: URL?
    @State var attLink: URL?
    @State var historical: Bool = false
    
    @Binding var weatherUpdated: Bool
    
    @Bindable var list: PackingList
    
    let service = WeatherService()
    
    var body: some View {
        
        // get/show weather
        if (!weatherUpdated) {
            // MARK: Button to load weather data
            Button {
                
                // clear array to prevent previous data being shown again
                weatherData = []
                
                // modify dates to include midnight
                let modifiedStart = Calendar.current.startOfDay(for: list.startDate)
                let modifiedEnd = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: list.endDate) ?? Date.distantFuture)
                
                // if the trip dates are fewer than 10 days in the future
                if (Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: modifiedEnd).day ?? 0 <= 10) {
                    
                    // get forecasted weather data
                    historical = false
                    
                    Task {
                        do {
                            let daily = try await service.weather(for: CLLocation(latitude: list.lat, longitude: list.long), including: .daily(startDate: modifiedStart, endDate: modifiedEnd))
                            daily.forecast.forEach { dayWeather in
                                weatherData.append(WeatherData(date: dayWeather.date, high: dayWeather.highTemperature, low: dayWeather.lowTemperature, condition: dayWeather.condition))
                            }
                            
                            withAnimation {
                                weatherUpdated = true
                                errorText = ""
                            }
                        }
                        catch {
                            withAnimation {
                                errorText = "There was a problem loading weather data. Please check that trip dates and destination are correct."
                            }
                        }
                    }
                    
                }
                
                // otherwise, use historical data for previous year
                else if let startLessYear = Calendar.current.date(byAdding: .year, value: -1, to: modifiedStart),
                        let endLessYear = Calendar.current.date(byAdding: .year, value: -1, to: modifiedEnd) {
                    
                    historical = true
                    
                    Task {
                        do {
                            let daily = try await service.weather(for: CLLocation(latitude: list.lat, longitude: list.long), including: .daily(startDate: startLessYear, endDate: endLessYear))
                            daily.forecast.forEach { dayWeather in
                                weatherData.append(WeatherData(date: dayWeather.date, high: dayWeather.highTemperature, low: dayWeather.lowTemperature, condition: dayWeather.condition))
                            }
                            
                            withAnimation {
                                weatherUpdated = true
                                errorText = ""
                            }
                        }
                        catch {
                            withAnimation {
                                errorText = "There was a problem loading weather data. Please check that trip dates and destination are correct."
                            }
                        }
                    }
                }
                
            } label: {
                Text("\(Image(systemName: "cloud.sun")) Load weather")
                    .bold()
                    .padding(10)
                    .background(.quaternary)
                    .clipShape(Capsule())
                    .padding(.vertical, 20)
            }
            .frame(maxWidth: .infinity)
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 10)
            .transition(.blurReplace)
        }
        else {
            
            // MARK: Horizontal scrolling weather display
            VStack(alignment: .leading) {
                
                HStack {
                    Text(historical ? "Historical weather" : "Forecast weather")
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .frame(height: 5)
                        .frame(maxWidth: .infinity)
                }
                .padding(.top, 10)
                .padding(.horizontal, 15)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(weatherData) { data in
                            
                            // component to show each day's date, conditions, high, and low
                            VStack {
                                Text(data.date.formatted(date: .abbreviated, time: .omitted))
                                Image(systemName: data.condition.getIconName())
                                    .font(.system(size: 26, weight: .heavy))
                                    .frame(height: 30)
                                    .padding(.bottom, 2)
                                HStack {
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                    Text(data.high.formatted(.measurement(width: .narrow, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))
                                    Image(systemName: "arrow.down")
                                        .foregroundColor(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                                    Text(data.low.formatted(.measurement(width: .narrow, usage: .weather, numberFormatStyle: .number.precision(.fractionLength(0)))))
                                }
                                .bold()
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .padding(.bottom, 8)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                
                // MARK: WeatherKit attribution
                HStack {
                    AsyncImage(url: attImage) { result in
                        result.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(height: 18)
                    .padding(.bottom, 2)
                    
                    Spacer()
                        
                    if let attLink {
                        Link("Other data sources", destination: attLink)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 10)
                
            }
            .task {
                do {
                    attImage = colorScheme == .light ? try await service.attribution.combinedMarkLightURL : try await service.attribution.combinedMarkDarkURL
                    attLink = try await service.attribution.legalPageURL
                }
                catch {
                    if (errorText.isEmpty) {
                        withAnimation {
                            errorText = "There was a problem loading attribution."
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(.quinary)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.bottom, 10)
            .transition(.blurReplace)
            
        }
        
        // MARK: Error message
        if (!errorText.isEmpty) {
            Text(errorText)
                .foregroundStyle(.red)
                .padding(15)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.top, 5)
                .transition(.blurReplace)
        }
        
    }
}
