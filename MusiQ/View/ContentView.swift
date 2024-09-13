//
//  ContentView.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @State private var songChartsResponse: [MusicCatalogChart<Song>] = []
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .task {
            await MusicKitAuthManager.shared.requestMusicAuthorization()
            do {
                songChartsResponse = try await MusicKitManager.shared.fetchCityTopChart(with: .alternative)
                print(songChartsResponse)
            } catch {
                print(error)
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
