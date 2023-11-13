//
//  LotOverviewResponse.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/13/23.
//

import Foundation

struct LotOverviewResponse: Decodable {
    private let lots: [LotOverview]
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }

        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
    }

    init(from decoder: Decoder) throws {
        var arrayContainer = try decoder.unkeyedContainer()

        var lotOverviews: [LotOverview] = []

        while !arrayContainer.isAtEnd {
            let locationContainer = try arrayContainer.nestedContainer(keyedBy: DynamicCodingKeys.self)

            for key in locationContainer.allKeys {
                if let index = key.intValue {
                    let location = try locationContainer.decode(LotOverview.self, forKey: DynamicCodingKeys(intValue: index)!)
                    lotOverviews.append(location)
                }
            }
        }

        self.lots = lotOverviews
    }
    
    func getLotOverviews() -> [LotOverview] {
        return self.lots.sorted(by: { $0.name < $1.name })
    }
}
