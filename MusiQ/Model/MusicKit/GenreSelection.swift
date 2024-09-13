//
//  GenreSelection.swift
//  MusiQ
//
//  Created by 조규연 on 9/13/24.
//

import Foundation

enum GenreSelection: String, CaseIterable, Identifiable {
    case all
    case alternative
    case singersong
    case dance
    case electronic
    case hiphop
    case kpop
    case rnb
    case rock
    case ost
    
    var id: Self { self }
    
    var genreData: GenreData {
        switch self {
        case .all:
            GenreData(name: "모든 장르", id: "34")
        case .alternative:
            GenreData(name: "얼터너티브", id: "20")
        case .singersong:
            GenreData(name: "싱어송라이터", id: "10")
        case .dance:
            GenreData(name: "댄스", id: "17")
        case .electronic:
            GenreData(name: "일렉트로닉", id: "7")
        case .hiphop:
            GenreData(name: "힙합/랩", id: "18")
        case .kpop:
            GenreData(name: "Kpop", id: "51")
        case .rnb:
            GenreData(name: "R&B/Soul", id: "15")
        case .rock:
            GenreData(name: "락", id: "21")
        case .ost:
            GenreData(name: "OST", id: "16")
        }
    }
}

extension GenreSelection {
    struct GenreData {
        let name: String
        let id: String
    }
}

/*
 Genre(id: "34", name: "Music"),
 Genre(id: "20", name: "Alternative"),
 Genre(id: "1229", name: "Baile Funk"),
 Genre(id: "2", name: "Blues"),
 Genre(id: "1221", name: "Bossa Nova"),
 Genre(id: "10", name: "Singer/Songwriter"),
 Genre(id: "6", name: "Country"),
 Genre(id: "17", name: "Dance"),
 Genre(id: "7", name: "Electronic"),
 Genre(id: "1223", name: "Forró"),
 Genre(id: "18", name: "Hip-Hop/Rap"),
 Genre(id: "11", name: "Jazz"),
 Genre(id: "51", name: "K-Pop"),
 Genre(id: "5", name: "Classical"),
 Genre(id: "12", name: "Latin"),
 Genre(id: "19", name: "Worldwide"),
 Genre(id: "4", name: "Children's Music"),
 Genre(id: "22", name: "Christian"),
 Genre(id: "1153", name: "Metal"),
 Genre(id: "1225", name: "MPB"),
 Genre(id: "14", name: "Pop"),
 Genre(id: "15", name: "R&B/Soul"),
 Genre(id: "24", name: "Reggae"),
 Genre(id: "21", name: "Rock"),
 Genre(id: "1227", name: "Samba"),
 Genre(id: "1228", name: "Sertanejo"),
 Genre(id: "16", name: "Soundtrack")
 */
