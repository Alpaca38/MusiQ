//
//  MusicKitManager.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import Foundation
import MusicKit


final class MusicKitManager: ObservableObject {
    static let shared = MusicKitManager()
    private init() {}
    
    private let player = ApplicationMusicPlayer.shared
    
    func fetchTopChart(with genre: GenreSelection) async throws -> [SongData] {
        do {
            let currentCountry = try await MusicDataRequest.currentCountryCode
            guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(currentCountry)/charts?types=songs&genre=\(genre.genreData.id)&limit=10") else {
                throw URLError(.badURL)
            }
            let request = MusicDataRequest(urlRequest: URLRequest(url: url))
            let response = try await request.response()
            
            let result = try JSONDecoder().decode(TopChart.self, from: response.data)
            return result.results.songs.first?.data ?? []
        } catch {
            print(error)
            return []
        }
    }
    
    func playMusic(id: MusicItemID) async throws {
        let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: id)
        let response = try await request.response()
        
        guard let song = response.items.first else { return }
        
        player.queue = [song]
        
        try await player.prepareToPlay()
        try await player.play()
    }
    
    func pauseMusic() {
        player.pause()
    }
}
