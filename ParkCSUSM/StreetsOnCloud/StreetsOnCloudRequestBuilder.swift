//
//  StreetsOnCloudRouter.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/12/23.
//

import Foundation

class StreetsOnCloudRequestBuilder {
    
    private let baseURL: URL = URL(string: "https://api.streetsoncloud.com")!
    private let apiKey: String

    init() {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
        else { fatalError("StreetsOnCloud API Key Not Defined.") }
        self.apiKey = apiKey
    }
    
    private func method(for endpoint: StreetsOnCloudEndpoint) -> HTTPMethod {
        switch endpoint {
        case .detailed, .overview:
            return .get
        }
    }
    
    private func path(for endpoint: StreetsOnCloudEndpoint) -> String {
        switch endpoint {
        case .detailed:
            return "pl1/location-info"
        case .overview:
            return "pl1/multi-lot-info"
        }
    }
    
    func headers(for endpoint: StreetsOnCloudEndpoint) -> [String: String]? {
        switch endpoint {
        case .detailed, .overview:
            return [
                "Accept": "application/json",
                "X-API-KEY": self.apiKey
            ]
        }
    }
    
    func request(for endpoint: StreetsOnCloudEndpoint) -> URLRequest {
        let url = self.baseURL.appendingPathComponent(self.path(for: endpoint))
        var request = URLRequest(url: url)
        request.httpMethod = self.method(for: endpoint).rawValue
        request.allHTTPHeaderFields = self.headers(for: endpoint)
        return request
    }
}

