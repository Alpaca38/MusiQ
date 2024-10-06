//
//  QuizIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/27/24.
//

import Foundation
import MusicKit

final class QuizIntent: QuizIntentProtocol {
    private weak var model: QuizActionsProtocol?
    
    init(model: QuizActionsProtocol) {
        self.model = model
    }
    
    func loadSongs(_ genre: GenreSelection, limit: Int) {
        model?.updateContentState(.loading)
        Task {
            await MusicKitAuthManager.shared.requestMusicAuthorization()
            do {
                let random = Int.random(in: 0...90)
                let songs = try await MusicKitManager.shared.fetchTopChart(with: genre, offset: random, limit: limit)
                let songList = try await MusicKitManager.shared.fetchCityTopChart(with: genre, offset: random, limit: limit)
                model?.updateContentState(.content(songs: songs, songList: songList))
                model?.updateLimit(limit)
            } catch {
                model?.updateContentState(.error(error.localizedDescription))
            }
        }
    }
    
    func togglePlay(_ isPlaying: Bool, _ url: URL?) {
        if isPlaying {
            SoundManager.shared.pauseSong()
            model?.cancelTimer()
        } else {
            SoundManager.shared.playSong(song: url)
            model?.setTimer()
        }
        model?.togglePlay()
    }
    
    func checkSongName(_ isPlaying: Bool) {
        if isPlaying {
            model?.togglePlay()
        }
        SoundManager.shared.pauseSong()
        model?.cancelTimer()
        model?.toggleSongPresented()
    }
    
    func checkArtistName() {
        model?.toggleArtworkPresented()
    }
    
    func dismiss() {
        model?.resetInput()
        model?.toggleSongPresented()
        model?.toggleArtworkPresented()
    }
    
    func updateSongField(_ input: String) {
        model?.updateSongName(input)
    }
    
    func updateArtistField(_ input: String) {
        model?.updateArtistName(input)
    }
    
    func saveHistory(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool) {
        model?.saveHistory(songs: songs, songList: songList, isCorrect: isCorrect)
    }
}

protocol QuizIntentProtocol {
    func loadSongs(_ genre: GenreSelection, limit: Int)
    func togglePlay(_ isPlaying: Bool, _ url: URL?)
    func checkSongName(_ isPlaying: Bool)
    func checkArtistName()
    func dismiss()
    func updateSongField(_ input: String)
    func updateArtistField(_ input: String)
    func saveHistory(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool)
}
