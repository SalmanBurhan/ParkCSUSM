//
//  StreetsOnCloud.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/12/23.
//

import Foundation

class StreetsOnCloud: ObservableObject {
    
    static let shared = StreetsOnCloud()
    let requestBuilder = StreetsOnCloudRequestBuilder()

    @Published var overview = [LotOverview]()
    
    init() {
        self.refresh()
    }
    
    func refresh() {
        Task {
            let _overview = try await self.fetchOverview()
            DispatchQueue.main.async {
                self.overview = _overview
            }
        }
    }
    
    private func fetchOverview() async throws -> [LotOverview] {
        let (data, _) = try await URLSession.shared.data(for: self.requestBuilder.request(for: .overview))
        let response = try JSONDecoder().decode(LotOverviewResponse.self, from: data)
        return response.getLotOverviews()
    }
    
}
