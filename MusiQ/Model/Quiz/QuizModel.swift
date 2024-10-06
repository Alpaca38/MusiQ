//
//  QuizModel.swift
//  MusiQ
//
//  Created by 조규연 on 9/27/24.
//

import Foundation
import MusicKit
import Combine
import RealmSwift

enum QuizContentState {
    case selectAmount
    case loading
    case content(songs: [SongData], songList: MusicItemCollection<Song>)
    case error(String)
}

final class QuizModel: ObservableObject, QuizStateProtocol {
    @Published var contentState: QuizContentState = .selectAmount
    @Published var isPlaying: Bool = false
    @Published var inputSongName: String = ""
    @Published var inputArtistName: String = ""
    @Published var isSongPresented: Bool = false
    @Published var isArtworkPresented: Bool = false
    @Published var cancellable: AnyCancellable?
    @Published var songAmount: Int = 10
    
    let categoryState: QuizCategoryStateProtocol
    let categoryIntent: QuizCategoryIntentProtocol
    
    @ObservedResults(Quiz.self)
    var quizList
    
    init(categoryState: QuizCategoryStateProtocol, categoryIntent: QuizCategoryIntentProtocol) {
        self.categoryState = categoryState
        self.categoryIntent = categoryIntent
    }
}

extension QuizModel: QuizActionsProtocol {
    func updateContentState(_ state: QuizContentState) {
        contentState = state
    }
    
    func togglePlay() {
        isPlaying.toggle()
    }
    
    func updateInputSongName(_ name: String) {
        inputSongName = name
    }
    
    func updateInputArtistName(_ name: String) {
        inputArtistName = name
    }
    
    func toggleSongPresented() {
        isSongPresented.toggle()
    }
    
    func toggleArtworkPresented() {
        isArtworkPresented.toggle()
    }
    
    func setTimer() {
        cancellable = Timer.publish(every: 30, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                self?.isPlaying = false
            }
    }
    
    func cancelTimer() {
        cancellable?.cancel()
    }
    
    func updateSongName(_ input: String) {
        inputSongName = input
    }
    
    func updateArtistName(_ input: String) {
        inputArtistName = input
    }
    
    func resetInput() {
        inputSongName = ""
        inputArtistName = ""
    }
    
    func saveHistory(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool) {
        if let currentSong = songs[safe: categoryState.currentSongIndex] , let currentSongList = songList[safe: categoryState.currentSongIndex] {
            $quizList.append(Quiz(mode: categoryState.mode.name, genre: categoryState.selectedGenre!.genreData.name, isCorrect: isCorrect, dataID: currentSong.id, artworkURL: currentSongList.artwork?.url(width: 50, height: 50)?.absoluteString, songName: currentSong.attributes.name, artistName: currentSong.attributes.artistName))
        }
    }
    
    func updateLimit(_ limit: Int) {
        songAmount = limit
    }
}

protocol QuizStateProtocol {
    var contentState: QuizContentState { get }
    var isPlaying: Bool { get }
    var inputSongName: String { get }
    var inputArtistName: String { get }
    var isSongPresented: Bool { get }
    var isArtworkPresented: Bool { get }
    var categoryState: QuizCategoryStateProtocol { get }
    var categoryIntent: QuizCategoryIntentProtocol { get }
    var songAmount: Int { get }
}

protocol QuizActionsProtocol: AnyObject {
    func updateContentState(_ state: QuizContentState)
    func togglePlay()
    func updateInputSongName(_ name: String)
    func updateInputArtistName(_ name: String)
    func toggleSongPresented()
    func toggleArtworkPresented()
    func setTimer()
    func cancelTimer()
    func updateSongName(_ input: String)
    func updateArtistName(_ input: String)
    func resetInput()
    func saveHistory(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool)
    func updateLimit(_ limit: Int)
}
