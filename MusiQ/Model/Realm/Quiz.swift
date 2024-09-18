//
//  Quiz.swift
//  MusiQ
//
//  Created by 조규연 on 9/18/24.
//

import Foundation
import RealmSwift

final class Quiz: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var mode: String
    @Persisted var genre: String
    @Persisted var isCorrect: Bool
    @Persisted var dataID: String
    @Persisted var artworkURL: String?
    @Persisted var songName: String
    @Persisted var artistName: String
    
    convenience init(mode: String, genre: String, isCorrect: Bool, dataID: String, artworkURL: String?, songName: String, artistName: String) {
        self.init()
        self.mode = mode
        self.genre = genre
        self.isCorrect = isCorrect
        self.dataID = dataID
        self.artworkURL = artworkURL
        self.songName = songName
        self.artistName = artistName
    }
}
