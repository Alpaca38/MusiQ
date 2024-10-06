//
//  QuizView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI
import MusicKit

struct QuizView: View {
    @StateObject var container: MVIContainer<QuizIntentProtocol, QuizStateProtocol>
    private var state: QuizStateProtocol { container.model }
    private var intent: QuizIntentProtocol { container.intent }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        contentView()
            .applyBackground()
            .onTapGesture {
                isFocused = false
            }
    }
    
    @ViewBuilder
    func contentView() -> some View {
        switch state.contentState {
        case .selectAmount:
            selectAmountView()
        case .loading:
            ProgressView("노래를 불러오는 중...")
        case .content(let songs, let songList):
            if state.categoryState.mode.name == Mode.song.name {
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
    
    func selectAmountView() -> some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.linearGradient(.init(colors: [.yellow, .orange]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 350, height: 350)
                
                let text = state.categoryState.mode.name == Mode.song.name ? "노래 듣고 맞추기" : "앨범커버 보고 맞추기"
                Text(text.localized)
                    .font(.custom("CookieRunOTF-Bold", size: 38))
                    .foregroundStyle(.text)
            }
            
            HStack(spacing: 15) {
                ForEach(SongAmount.allCases, id: \.self) { item in
                    Text("\(item.limit)개")
                        .asDefaultButtonStyle()
                        .asButton {
                            intent.loadSongs(state.categoryState.selectedGenre!, limit: item.limit)
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func songView(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        VStack(spacing: 50) {
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.linearGradient(.init(colors: [.green, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 350, height: 350)
                playButton(songList[state.categoryState.currentSongIndex].previewAssets?.first?.url)
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
                    intent.saveHistory(songs: songs, songList: songList, isCorrect: checkSongNameCorrect(songs: songs))
                }
        }
        .padding()
    }
    
    @ViewBuilder
    func artworkView(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        VStack(spacing: 40) {
            if let currentSongList = songList[safe: state.categoryState.currentSongIndex], let artwork = currentSongList.artwork {
                ArtworkImage(artwork, width: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
            }
            
            inputArtistField(songs: songs, songList: songList)
        }
    }
    
    func inputArtistField(songs: [SongData], songList: MusicItemCollection<Song>) -> some View {
        HStack {
            TextField("가수 이름을 띄어쓰기 없이 입력해주세요.", text: Binding(
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
                    intent.saveHistory(songs: songs, songList: songList, isCorrect: checkArtistNameCorrect(songs: songs))
                }
                .asDefaultButtonStyle()
        }
        .padding()
    }
    
    @ViewBuilder
    func createSongCheckView(songs: [SongData], songList: MusicItemCollection<Song>, isCorrect: Bool) -> some View {
        if let currentSong = songs[safe: state.categoryState.currentSongIndex],
           let currentSongList = songList[safe: state.categoryState.currentSongIndex] {
            NavigationLazyView(SongCheckView.build(
                mode: state.categoryState.mode,
                genre: state.categoryState.selectedGenre!,
                isCorrect: isCorrect,
                songData: currentSong,
                currentSongList: currentSongList,
                currentIndex: state.categoryState.currentSongIndex,
                categoryIntent: state.categoryIntent,
                quizIntent: intent,
                songAmount: state.songAmount
            ))
        }
    }
    
    func checkSongNameCorrect(songs: [SongData]) -> Bool {
        songs[safe: state.categoryState.currentSongIndex].map { state.inputSongName.localizedCaseInsensitiveContains($0.attributes.answerSongName) } ?? false
    }
    
    func checkArtistNameCorrect(songs: [SongData]) -> Bool {
        songs[safe: state.categoryState.currentSongIndex].map { state.inputArtistName.localizedCaseInsensitiveContains($0.attributes.answerArtistName) } ?? false
    }
}

extension QuizView {
    static func build(_ categoryState: QuizCategoryStateProtocol, _ categoryIntent: QuizCategoryIntentProtocol) -> some View {
        let model = QuizModel(categoryState: categoryState, categoryIntent: categoryIntent)
        let intent = QuizIntent(model: model)
        let container = MVIContainer(intent: intent as QuizIntentProtocol,
                                     model: model as QuizStateProtocol,
                                     modelChangePublisher: model.objectWillChange)
        return QuizView(container: container)
    }
    
    private enum SongAmount: CaseIterable, Hashable {
        case ten
        case twenty
        case thirty
        case fourty
        case fifty
        
        var limit: Int {
            switch self {
            case .ten:
                10
            case .twenty:
                20
            case .thirty:
                30
            case .fourty:
                40
            case .fifty:
                50
            }
        }
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
