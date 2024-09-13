//
//  MusicKitManager.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import Foundation
import MusicKit

struct Genres: Decodable {
    let data: [Genre]
}

final class MusicKitManager: ObservableObject {
    static let shared = MusicKitManager()
    private init() {}
    
    func fetchCityTopChart(with genreSelection: GenreSelection) async throws -> [MusicCatalogChart<Song>] {
        let genre = try await getGenre(genreSelection)
        var request = MusicCatalogChartsRequest(
            genre: genre.data.first,
            kinds: [.cityTop],
            types: [Song.self]
        )
        request.limit = 10
        request.offset = 0
        
        return try await request.response().songCharts
    }
    
    func getGenre(_ genreSelection: GenreSelection) async throws -> Genres {
        do {
            let genreID = genreSelection.genreData.id
            let countryCode = try await MusicDataRequest.currentCountryCode
            
            let genreURL = "https://api.music.apple.com/v1/catalog/\(countryCode)/genres/\(genreID)"
            
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
