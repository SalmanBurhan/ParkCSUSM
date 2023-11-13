//
//  LotOverviewView.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/13/23.
//

import SwiftUI
import MapKit

struct LotOverviewView: View {
    
    let lot: LotOverview
        
    init(for lot: LotOverview) {
        self.lot = lot
    }
    
    var mapView: some View {
        Map(initialPosition: .item(
            MKMapItem(placemark: .init(coordinate: lot.location))))
        .allowsHitTesting(false)
        .frame(width: 100, height: 100)
        .mask(LinearGradient(gradient: Gradient(
            colors:[Color.black, Color.black, Color.black, Color.black.opacity(0)]),
             startPoint: .leading, endPoint: .trailing))
        .clipShape(UnevenRoundedRectangle(
            cornerRadii: RectangleCornerRadii(
            topLeading: 15,
            bottomLeading: 15),
            style: .continuous))
    }
    
    var nameLabel: some View {
        Text(lot.name.replacingOccurrences(of: "&amp;", with: "&").uppercased())
        .font(.headline)
    }
    
    var availabilityView: some View {
        ProgressView(value: lot.percentFull) {
            Text("\(lot.free) of \(lot.total) Available").font(.callout)
        } currentValueLabel: {
            HStack {
                Text(String(format: "%0.0f%% Full", lot.percentFull * 100))
                Spacer()
                Text(String(format: "%0.0f%% Empty", lot.percentEmpty * 100))
            }
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
            startPoint: .leading,
            endPoint: .trailing)
    }

    var body: some View {
        HStack(alignment: .center) {
            self.mapView
            VStack(alignment: .leading) {
                self.nameLabel
                self.availabilityView
            }
            Spacer()
        }
        .background(self.colorGradient)
        .padding([.leading, .trailing], 5)
    }
    
}
