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
    let categoryState: QuizCategoryStateProtocol
    let categoryIntent: QuizCategoryIntentProtocol
    
    @StateObject var container: MVIContainer<QuizIntentProtocol, QuizStateProtocol>
    private var state: QuizStateProtocol { container.model }
    private var intent: QuizIntentProtocol { container.intent }
    
    @FocusState private var isFocused: Bool
    
    @ObservedResults(Quiz.self)
    var quizList
    
    var body: some View {
        contentView()
            .task {
                intent.loadSongs(categoryState.selectedGenre!)
            }
            .applyBackground()
            .onTapGesture {
                isFocused = false
            }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        switch state.contentState {
        case .loading:
            ProgressView("노래를 불러오는 중...")
        case .content(let songs, let songList):
            if categoryState.mode.name == Mode.song.name {
                songView(songs: songs, songList: songList)
                    .fullScreenCover(isPresented: Binding.constant(state.isSongPresented), content: {
                        createSongCheckView(songs: songs, songList: songList, isCorrect: checkSongNameCorrect(songs: songs))
                    })
            } else {
                artworkView(songs: songs, songList: songList)
                    .fullScreenCover(isPresented: Binding.constant(state.isArtworkPresented), content: {
                        createSongCheckView(songs: songs, songList: songList, isCorrect: checkArtistNameCorrect(songs: songs))
                    })
            }
        case .error(let string):
            Text(string)
        }
    }
    
    @ViewBuilder
    func songView(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        VStack(spacing: 50) {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.linearGradient(.init(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 350, height: 350)
                playButton(songList[categoryState.currentSongIndex].previewAssets?.first?.url)
            }
            inputSongField(songs: songs, songList: songList)
        }
    }
    
    func playButton(_ url: URL?) -> some View {
        Image(systemName: state.isPlaying ? "pause.circle" : "play.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .foregroundStyle(.playButton)
            .asButton {
                intent.togglePlay(state.isPlaying, url)
            }
    }
    
    func inputSongField(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        HStack {
            TextField("제목을 띄어쓰기 없이 입력해주세요.", text: Binding(
                get: { state.inputSongName },
                set: { input in
                    intent.updateSongField(input)
                }
            ))
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
            Text("확인")
                .asDefaultButtonStyle()
                .asButton {
                    intent.checkSongName(state.isPlaying)
                    saveHistory(songs: songs, songList: songList, isCorrect: checkSongNameCorrect(songs: songs))
                }
        }
        .padding()
    }
    
    @ViewBuilder
    func artworkView(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        VStack(spacing: 40) {
            if let currentSongList = songList[safe: categoryState.currentSongIndex], let artwork = currentSongList.artwork {
                ArtworkImage(artwork, width: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
            }
            
            inputArtistField(songs: songs, songList: songList)
        }
    }
    
    func inputArtistField(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        HStack {
            TextField("가수 이름을 입력해주세요.", text: Binding(
                get: { state.inputArtistName },
                set: { input in
                    intent.updateArtistField(input)
                }
            ))
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
            Text("확인")
                .asButton {
                    intent.checkArtistName()
                    saveHistory(songs: songs, songList: songList, isCorrect: checkArtistNameCorrect(songs: songs))
                }
                .asDefaultButtonStyle()
        }
        .padding()
    }
    
    func saveHistory(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool) {
        if let currentSong = songs[safe: categoryState.currentSongIndex] , let currentSongList = songList[safe: categoryState.currentSongIndex] {
            $quizList.append(Quiz(mode: categoryState.mode.name, genre: categoryState.selectedGenre!.genreData.name, isCorrect: isCorrect, dataID: currentSong.id, artworkURL: currentSongList.artwork?.url(width: 50, height: 50)?.absoluteString, songName: currentSong.attributes.name, artistName: currentSong.attributes.artistName))
        }
    }
    
    @ViewBuilder
    func createSongCheckView(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool) -> some View {
        if let currentSong = songs[safe: categoryState.currentSongIndex],
           let currentSongList = songList[safe: categoryState.currentSongIndex] {
            NavigationLazyView(SongCheckView(
                mode: categoryState.mode,
                genre: categoryState.selectedGenre!,
                isCorrect: isCorrect,
                songData: currentSong,
                currentSongList: currentSongList,
                currentIndex: categoryState.currentSongIndex,
                categoryIntent: categoryIntent,
                inputSongName: Binding.constant(state.inputSongName),
                inputArtistName: Binding.constant(state.inputArtistName),
                quizIntent: intent
            ))
        }
    }
    
    func checkSongNameCorrect(songs: [SongData]) -> Bool {
        songs[safe: categoryState.currentSongIndex].map { state.inputSongName.localizedCaseInsensitiveContains($0.attributes.answerSongName) } ?? false
    }
    
    func checkArtistNameCorrect(songs: [SongData]) -> Bool {
        songs[safe: categoryState.currentSongIndex].map { state.inputArtistName.localizedCaseInsensitiveContains($0.attributes.answerArtistName) } ?? false
    }
}

extension QuizView {
    static func build(_ categoryState: QuizCategoryStateProtocol, _ categoryIntent: QuizCategoryIntentProtocol) -> some View {
        let model = QuizModel()
        let intent = QuizIntent(model: model)
        let container = MVIContainer(intent: intent as QuizIntentProtocol,
                                     model: model as QuizStateProtocol,
                                     modelChangePublisher: model.objectWillChange)
        return QuizView(categoryState: categoryState, categoryIntent: categoryIntent, container: container)
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
