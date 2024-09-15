//
//  QuizView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizView: View {
    let mode: Mode
    let genre: GenreSelection
    
    @State private var isPlaying = false
    @State private var inputSongName = ""
    @State private var inputArtistName = ""
    
    var body: some View {
        if mode.name == Mode.song.name {
            songView()
        } else {
            artworkView()
        }
    }
    
    func songView() -> some View {
        VStack(spacing: 100) {
            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .asButton {
                                togglePlay()
                            }
            
            HStack {
                TextField("노래 제목을 입력해주세요.", text: $inputSongName)
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
    
    func togglePlay() {
        if isPlaying {
            
        } else {
            
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
}


//
//#Preview {
//    QuizView()
//}
