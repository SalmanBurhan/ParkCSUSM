//
//  AltLotOverview.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/13/23.
//

import SwiftUI

import SwiftUI
import MapKit

struct AltLotOverviewView: View {
    
    @State var lot: LotOverview
    
    var mapView: some View {
        Map(initialPosition: MapCameraPosition.item(
            MKMapItem(placemark: MKPlacemark(
                coordinate: self.lot.location))))
        .allowsHitTesting(false)
        .frame(width: .infinity, height: 200)
        .mask(LinearGradient(gradient: Gradient(
            colors:[Color.black, Color.black, Color.black, Color.black.opacity(0)]),
             startPoint: .top, endPoint: .bottom))
        .clipShape(UnevenRoundedRectangle(
            cornerRadii: RectangleCornerRadii(
            topLeading: 25,
            topTrailing: 25),
            style: .continuous))
    }
    
    var nameLabel: some View {
        Text(lot.name.replacingOccurrences(of: "&amp;", with: "&").uppercased())
        .font(.title3.bold())
        .padding(.top)
    }
    
    var availabilityView: some View {
        ProgressView(value: lot.percentFull) { } currentValueLabel: {
            HStack {
                Text(String(format: "%0.0f%% Full", lot.percentFull * 100))
                Spacer()
                Text("\(lot.free) of \(lot.total)")
                Spacer()
                Text(String(format: "%0.0f%% Empty", lot.percentEmpty * 100))
            }
            .padding([.leading, .trailing])
            .padding([.bottom], 10)
        }.tint(self.tintColor)
    }
    
    var tintColor: Color {
        switch self.lot.percentFull {
        case 0.0 ... 0.25:
            return Color.green
        case 0.25 ... 0.50:
            return Color.yellow
        case 0.50 ... 0.75:
            return Color.orange
        case 0.75 ... 1.0:
            return Color.red
        default:
            return Color.accentColor
        }
    }
    
    var colorGradient: some View {
        var colors: [Color] = [Color.clear]
        
        switch self.lot.percentFull {
        case 0.0 ... 0.25:
            colors.append(Color.green.opacity(0.25))
        case 0.25 ... 0.50:
            colors.append(Color.yellow.opacity(0.25))
        case 0.50 ... 0.75:
            colors.append(Color.orange.opacity(0.25))
        case 0.75 ... 1.0:
            colors.append(Color.red.opacity(0.25))
        default:
            colors.append(Color.blue)
        }
        
        return LinearGradient(
            gradient: Gradient(colors:colors),
            startPoint: .bottom,
            endPoint: .top)
    }
 
    var cardOverlay: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, content: {
                self.nameLabel
                self.availabilityView
            })
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 25, style: .continuous).fill(.ultraThinMaterial))
        .padding([.top], 150)
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            self.mapView
            self.cardOverlay
        })
    }
}
