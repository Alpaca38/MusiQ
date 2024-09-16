//
//  QuizView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI
import MusicKit

struct QuizView: View {
    let mode: Mode
    let genre: GenreSelection
    @Binding var currentSongIndex: Int
    
    @State private var isPlaying = false
    @State private var inputSongName = ""
    @State private var inputArtistName = ""
    @State private var songs: [SongData] = []
    @State private var isLoading = false
    
    var body: some View {
        if mode.name == Mode.song.name {
            songView()
                .task {
                    await loadSongs()
                }
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
                        .asButton {
                            togglePlay()
                        }
    }
    
    func inputSongField() -> some View {
        HStack {
            TextField("노래 제목을 입력해주세요.", text: $inputSongName)
                .textFieldStyle(.roundedBorder)
            NavigationLink {
                let currentSong = songs[safe: currentSongIndex]
                let isCorrect = inputSongName.localizedCaseInsensitiveContains(currentSong?.attributes.name ?? "")
                NavigationLazyView(SongCheckView(mode: mode, genre: genre, isCorrect: isCorrect, songData: currentSong, currentIndex: $currentSongIndex))
            } label: {
                Text("확인")
                    .asDefaultButtonStyle()
            }
        }
        .padding()
    }
    
    func togglePlay() {
        if isPlaying {
            MusicKitManager.shared.pauseMusic()
        } else {
            Task {
                let currentSong = songs[safe: currentSongIndex]
                try await MusicKitManager.shared.playMusic(id: MusicItemID(currentSong?.id ?? ""))
            }
        }
        isPlaying.toggle()
    }
    
    func artworkView() -> some View {
        VStack(spacing: 40) {
            AsyncImage(url: URL(string: "dummy")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                case .failure(_):
                    Color.gray
                @unknown default:
                    Color.gray
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            .frame(width: 350, height: 350)
            
            HStack {
                TextField("가수 이름을 입력해주세요.", text: $inputArtistName)
                    .textFieldStyle(.roundedBorder)
                Text("확인")
                    .asButton {
                        print("정답 확인")
                    }
                    .asDefaultButtonStyle()
            }
            .padding()
        }
    }
    
    func loadSongs() async {
        isLoading = true
        await MusicKitAuthManager.shared.requestMusicAuthorization()
        do {
            songs = try await MusicKitManager.shared.fetchTopChart(with: genre)
        } catch {
            print(error)
        }
        isLoading = false
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
