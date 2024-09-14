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
    @State private var songs: Songs = []
    
    var body: some View {
        VStack {
            List {
                ForEach(songs.first?.data ?? [], id: \.id) { item in
                    Text(item.attributes.name)
                }
            }
        }
        .padding()
        .task {
            await MusicKitAuthManager.shared.requestMusicAuthorization()
            do {
                songs = try await MusicKitManager.shared.fetchTopChart(with: .ost)
                print(songs)
            } catch {
                print(error)
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
