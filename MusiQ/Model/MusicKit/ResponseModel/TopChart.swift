//
//  TopChart.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import Foundation

struct TopChart: Decodable {
    let results: TopChartResults
}

struct TopChartResults: Decodable {
    let songs: Songs
}

struct SongItem: Decodable {
    let next: String
    let data: SongsData
    let href: String
}

struct SongData: Decodable {
    let id: String
    let href: String
    let attributes: SongAttributes
}

struct SongAttributes: Decodable {
    let artwork: Artwork
    let playParams: PlayParams
    let url: String
    let name: String
    let artistName: String
    
    var answerSongName: String {
        name.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: #"\s*\(feat\..*?\)"#, with: "", options: .regularExpression)
    }
}

struct Artwork: Decodable {
    let url: String
}

struct PlayParams: Decodable {
    let id: String
    let kind: String
}

typealias Songs = [SongItem]
typealias SongsData = [SongData]
