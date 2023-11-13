//
//  LotOverview.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/12/23.
//

import Foundation
import RegexBuilder
import MapKit
import SwiftUI

struct LotOverview: Decodable {
    var id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    let address: String
    let total: Int
    let free: Int
    let percentFull: Float
    let percentEmpty: Float
    
    //var region: MapCameraPosition
    
    private enum CodingKeys: String, CodingKey {
        case name = "location_name"
        case geocode
        case address = "location_address"
        case total = "total_spaces"
        case free = "free_spaces"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        
        let total = try container.decode(String.self, forKey: .total)
        let free = try container.decode(String.self, forKey: .free)
        
        self.total = Int(total)!
        self.free = Int(free)!

        self.percentEmpty = Float(self.free) / Float(self.total)
        self.percentFull = 1.0 - (Float(self.free) / Float(self.total))
        
        let geocode = try container.decode(String.self, forKey: .geocode)

        let latitude = Reference(Substring.self)
        let longitude = Reference(Substring.self)
        let geocodePattern = Regex {
            Capture(as: latitude) {
                Regex {
                    Optionally {
                        "-"
                    }
                    OneOrMore(.digit)
                    /./
                    OneOrMore(.digit)
                }
            }
            ","
            Capture(as: longitude) {
                Regex {
                    Optionally {
                        "-"
                    }
                    OneOrMore(.digit)
                    /./
                    OneOrMore(.digit)
                }
            }
        }
        let match = geocode.firstMatch(of: geocodePattern)
        let lat = match![latitude]
        let long = match![longitude]
        let location = CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(long)!)
        self.location = location
        
//        self.region = MapCameraPosition.region(
//            MKCoordinateRegion(
//                center: self.location,
//                latitudinalMeters: 202,
//                longitudinalMeters: 0
//            )
//        )
    }
}
