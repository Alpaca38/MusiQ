//
//  SongCheckModel.swift
//  MusiQ
//
//  Created by 조규연 on 9/30/24.
//

import Foundation
import MusicKit

final class SongCheckModel: ObservableObject, SongCheckStateProtocol {
    var mode: Mode
    var genre: GenreSelection
    var isCorrect: Bool
    var songData: SongData
    var currentSongList: Song
    var currentIndex: Int
    var categoryIntent: any QuizCategoryIntentProtocol
    var quizIntent: any QuizIntentProtocol
    var songAmount: Int
    
    init(mode: Mode, genre: GenreSelection, isCorrect: Bool, songData: SongData, currentSongList: Song, currentIndex: Int, categoryIntent: any QuizCategoryIntentProtocol, quizIntent: any QuizIntentProtocol, songAmount: Int) {
        self.mode = mode
        self.genre = genre
        self.isCorrect = isCorrect
        self.songData = songData
        self.currentSongList = currentSongList
        self.currentIndex = currentIndex
        self.categoryIntent = categoryIntent
        self.quizIntent = quizIntent
        self.songAmount = songAmount
    }
}

protocol SongCheckStateProtocol: AnyObject {
    var mode: Mode { get }
    var genre: GenreSelection { get }
    var isCorrect: Bool { get }
    var songData: SongData { get }
    var currentSongList: Song { get }
    var currentIndex: Int { get }
    var categoryIntent: QuizCategoryIntentProtocol { get }
    var quizIntent: QuizIntentProtocol { get }
    var songAmount: Int { get }
}
