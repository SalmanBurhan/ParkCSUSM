//
//  ContentView.swift
//  ParkCSUSM
//
//  Created by Salman Burhan on 11/12/23.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @ObservedObject var streetsOnCloud = StreetsOnCloud.shared
    @State var useAltView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(self.streetsOnCloud.overview, id: \.id) { lot in
                        if self.useAltView {
                            AltLotOverviewView(lot: lot)
                        } else {
                            LotOverviewView(for: lot)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("Park CSUSM")
            .toolbar {
                Button {
                    self.useAltView.toggle()
                } label: {
                    Image(systemName: "rectangle.2.swap")
                }
            }
            .onAppear() {
                self.streetsOnCloud.refresh()
            }
        }
    }
}

#Preview {
    ContentView()
}
