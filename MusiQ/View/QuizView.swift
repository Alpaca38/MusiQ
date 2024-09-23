//
//  QuizView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI
import MusicKit
import RealmSwift
import Combine

struct QuizView: View {
    let mode: Mode
    let genre: GenreSelection
    @Binding var currentSongIndex: Int
    
    @State private var isPlaying = false
    @State private var inputSongName = ""
    @State private var inputArtistName = ""
    @State private var songs: [SongData] = []
    @State private var songList: MusicItemCollection<Song> = []
    @State private var isLoading = false
    @State private var isSongPresented = false
    @State private var isArtworkPresented = false
    @State private var cancellable: AnyCancellable?
    
    @FocusState private var isFocused: Bool
    
    @ObservedResults(Quiz.self)
    var quizList
    
    var body: some View {
        contentView()
            .task {
                await loadSongs()
            }
            .fullScreenCover(isPresented: $isSongPresented, content: {
                createSongCheckView(isCorrect: checkSongNameCorrect())
            })
            .fullScreenCover(isPresented: $isArtworkPresented, content: {
                createSongCheckView(isCorrect: checkArtistNameCorrect())
            })
            .applyBackground()
            .onTapGesture {
                isFocused = false
            }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        if mode.name == Mode.song.name {
            songView()
        } else {
            artworkView()
        }
    }
    
    @ViewBuilder
    func songView() -> some View {
        if isLoading {
            ProgressView("노래를 불러오는 중...")
        } else {
            VStack(spacing: 100) {
                playButton()
                inputSongField()
            }
        }
    }
    
    func playButton() -> some View {
        Image(systemName: isPlaying ? "pause.circle" : "play.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundStyle(.playButton)
            .asButton {
                togglePlay()
            }
    }
    
    func inputSongField() -> some View {
        HStack {
            TextField("제목을 띄어쓰기 없이 입력해주세요.", text: $inputSongName)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
            Text("확인")
                .asDefaultButtonStyle()
                .asButton {
                    isPlaying = false
                    MusicKitManager.shared.pauseMusic()
                    cancellable?.cancel() // 타이머 캔슬
                    
                    isSongPresented.toggle()
                    if let currentSong = songs[safe: currentSongIndex] {
                        let isCorrect = inputSongName.localizedCaseInsensitiveContains(currentSong.attributes.answerSongName)
                        saveHistory(isCorrect: isCorrect)
                    }
                }
        }
        .padding()
    }
    
    func togglePlay() {
        if isPlaying {
            MusicKitManager.shared.pauseMusic()
            cancellable?.cancel()
        } else {
            Task {
                let currentSong = songs[safe: currentSongIndex]
                try await MusicKitManager.shared.playMusic(id: MusicItemID(currentSong?.id ?? ""))
                cancellable = Timer.publish(every: 30, on: .main, in: .common)
                    .autoconnect()
                    .first()
                    .sink { _ in
                        MusicKitManager.shared.pauseMusic()
                        isPlaying = false
                    }
            }
        }
        isPlaying.toggle()
    }
    
    @ViewBuilder
    func artworkView() -> some View {
        if isLoading {
            ProgressView("노래를 불러오는 중...")
        } else {
            VStack(spacing: 40) {
                if let currentSongList = songList[safe: currentSongIndex], let artwork = currentSongList.artwork {
                    ArtworkImage(artwork, width: 350)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                
                inputArtistField()
            }
        }
    }
    
    func inputArtistField() -> some View {
        HStack {
            TextField("가수 이름을 입력해주세요.", text: $inputArtistName)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
            Text("확인")
                .asButton {
                    isArtworkPresented.toggle()
                    if let currentSong = songs[safe: currentSongIndex] {
                        let isCorrect = inputArtistName.localizedCaseInsensitiveContains(currentSong.attributes.answerArtistName)
                        saveHistory(isCorrect: isCorrect)
                    }
                }
                .asDefaultButtonStyle()
        }
        .padding()
    }
    
    func saveHistory(isCorrect: Bool) {
        if let currentSong = songs[safe: currentSongIndex] , let currentSongList = songList[safe: currentSongIndex] {
            $quizList.append(Quiz(mode: mode.name, genre: genre.genreData.name, isCorrect: isCorrect, dataID: currentSong.id, artworkURL: currentSongList.artwork?.url(width: 50, height: 50)?.absoluteString, songName: currentSong.attributes.name, artistName: currentSong.attributes.artistName))
        }
    }
    
    func loadSongs() async {
        isLoading = true
        await MusicKitAuthManager.shared.requestMusicAuthorization()
        do {
            songs = try await MusicKitManager.shared.fetchTopChart(with: genre)
            songList = try await MusicKitManager.shared.fetchCityTopChart(with: genre)
        } catch {
            print(error)
        }
        isLoading = false
    }
    
    @ViewBuilder
    func createSongCheckView(isCorrect: Bool) -> some View {
        if let currentSong = songs[safe: currentSongIndex],
           let currentSongList = songList[safe: currentSongIndex] {
            NavigationLazyView(SongCheckView(
                mode: mode,
                genre: genre,
                isCorrect: isCorrect,
                songData: currentSong,
                currentSongList: currentSongList,
                currentIndex: $currentSongIndex,
                inputSongName: $inputSongName,
                inputArtistName: $inputArtistName
            ))
        }
    }
    
    func checkSongNameCorrect() -> Bool {
        songs[safe: currentSongIndex].map { inputSongName.localizedCaseInsensitiveContains($0.attributes.answerSongName) } ?? false
    }
    
    func checkArtistNameCorrect() -> Bool {
        songs[safe: currentSongIndex].map { inputArtistName.localizedCaseInsensitiveContains($0.attributes.answerArtistName) } ?? false
    }
}


//
//#Preview {
//    QuizView()
//}
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension MusicItemCollection<Song> {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
