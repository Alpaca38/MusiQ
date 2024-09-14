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
    
    func fetchTopChart(with genre: GenreSelection) async throws -> Songs {
        do {
            let currentCountry = try await MusicDataRequest.currentCountryCode
            guard let url = URL(string: "https://api.music.apple.com/v1/catalog/\(currentCountry)/charts?types=songs&genre=\(genre.genreData.id)&limit=10") else {
                throw URLError(.badURL)
            }
            let request = MusicDataRequest(urlRequest: URLRequest(url: url))
            let response = try await request.response()
            
            let result = try JSONDecoder().decode(TopChart.self, from: response.data)
            return result.results.songs
        } catch {
            print(error)
            return []
        }
    }
    
    func getGenre(_ genreID: String) async throws -> Genres {
        do {
            let genreURL = "https://api.music.apple.com/v1/catalog/kr/genres/\(genreID)"
            
            guard let url = URL(string: genreURL) else {
                throw URLError(.badURL)
            }
            
            let request = MusicDataRequest(urlRequest: URLRequest(url: url))
            let response = try await request.response()
            
            let genre = try JSONDecoder().decode(Genres.self, from: response.data)
            return genre
        } catch {
            print(error)
            return Genres(data: [])
        }
    }
}
