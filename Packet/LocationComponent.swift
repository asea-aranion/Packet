//
//  LocationComponent.swift
//  Packet
//
//  Created by Leia Spagnola on 1/3/25.
//

import CoreLocation
import SwiftUI

extension CLPlacemark {
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
    
    @Bindable var list: PackingList
    
    var body: some View {
        
        // view/edit destination
        
        HStack(spacing: 0) {
            
            Image(systemName: "mappin.and.ellipse")
            
            VStack(spacing: 0) {
                
                if (inEditMode) {
                    TextField("Location", text: $locText)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .padding(.top, 5)
                }
                else {
                    Text(placemark?.locationString() ?? "(No location)")
                        .bold()
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
            
            Button {
                if (!inEditMode) {
                    
                    withAnimation(.easeInOut) {
                        inEditMode = true
                    }
                }
                else {
                    CLGeocoder().geocodeAddressString(locText, completionHandler: { (placemarks, error) in
                        if error == nil, let realPlacemark = placemarks?.first {
                            placemark = realPlacemark
                            list.long = realPlacemark.location?.coordinate.longitude ?? 0
                            list.lat = realPlacemark.location?.coordinate.latitude ?? 0
                            withAnimation(.easeInOut) {
                                errorText = ""
                                inEditMode = false
                            }
                            
                        }
                        else {
                            errorText = "Location could not be found."
                        }
                    })
                }
                
            } label: {
                Image(systemName: inEditMode ? "checkmark" : "pencil")
                    .font(.system(size: 22, weight: .heavy))
                    .padding(.horizontal, 15)
                    .foregroundStyle(Color(red: list.colorRed, green: list.colorGreen, blue: list.colorBlue))
            }
            
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .background(.quinary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(.plain)
        .padding(.bottom, 10)
        
        .onAppear {
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: list.lat, longitude: list.long),
                                                completionHandler: { (placemarks, error) in
                if let realPlacemark = placemarks?.first {
                    placemark = realPlacemark
                }
                
            })
        }
        
        if (!errorText.isEmpty) {
            Text(errorText)
                .foregroundStyle(.red)
                .padding(15)
                .background(.quinary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 10)
        }
       
        
    }
}
