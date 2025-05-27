//
//  LocationComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 1/3/25.
//

import CoreLocation
import SwiftUI
import WeatherKit

extension CLPlacemark {
    /// Gets a string representation of a placemark to display
    func locationString() -> String {
        
        var result: String = ""
        
        if let loc = locality {
            result += loc + ", "
        }
        
        if let admin = administrativeArea {
            result += admin + ", "
        }
        
        if let ctry = country {
            result += ctry
        }
        
        return result.isEmpty ? "(No Location)" : result
    }
}

struct LocationComponent: View {
    @State var locText: String = ""
    @State var placemark: CLPlacemark?
    @State var errorText: String = ""
    @State var inEditMode: Bool = false
    
    @Binding var weatherUpdated: Bool
    
    @Bindable var list: PackingList
    
    var body: some View {
        
        // view/edit destination
        
        HStack(spacing: 0) {
            
            Image(systemName: "mappin.and.ellipse")
            
            // MARK: Location text display and field
            VStack(spacing: 0) {
                
                if (inEditMode) {
                    TextField("Location", text: $locText)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                }
                else {
                    Text(placemark?.locationString() ?? "(No location)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 5)
                    
                    
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                    .frame(height: 5)
                    .frame(maxWidth: inEditMode ? .infinity : 0)
                
            }
            .padding(.horizontal, 10)
            
            // MARK: Edit button
            Button {
                if (!inEditMode) {
                    withAnimation(.easeInOut) {
                        inEditMode = true
                    }
                }
                else {
                    // attempts to get coordinates for user-entered location string
                    CLGeocoder().geocodeAddressString(locText, completionHandler: { (placemarks, error) in
                        if error == nil, let realPlacemark = placemarks?.first {
                            placemark = realPlacemark
                            list.long = realPlacemark.location?.coordinate.longitude ?? 0
                            list.lat = realPlacemark.location?.coordinate.latitude ?? 0
                            withAnimation(.easeInOut) {
                                errorText = ""
                                inEditMode = false
                                weatherUpdated = false
                            }
                            
                        }
                        else {
                            withAnimation {
                                errorText = "Location could not be found. Please try again."
                            }
                        }
                    })
                }
                
            } label: {
                if (!inEditMode) {
                    Text("Edit")
                        .bold()
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(.quaternary)
                        .clipShape(Capsule())
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                } else {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 15)
                        .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
                        .accessibilityHint("Saves location")
                }
                
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(.plain)
        .padding(.bottom, 10)
        
        .onAppear {
            // gets placemark for coordinates stored in PackingList
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: list.lat, longitude: list.long),
                                                completionHandler: { (placemarks, error) in
                if let realPlacemark = placemarks?.first {
                    placemark = realPlacemark
                }
                
            })
        }
        
        // MARK: Error message
        if (!errorText.isEmpty) {
            Text(errorText)
                .foregroundStyle(.red)
                .padding(15)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 10)
                .transition(.blurReplace)
        }
        
    }
}
