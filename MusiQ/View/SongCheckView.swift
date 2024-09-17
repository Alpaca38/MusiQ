//
//  SongCheckView.swift
//  MusiQ
//
//  Created by 조규연 on 9/16/24.
//

import SwiftUI
import MusicKit

struct SongCheckView: View {
    let mode: Mode
    let genre: GenreSelection
    let isCorrect: Bool
    let songData: SongData
    let currentSongList: Song
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack(spacing: 40) {
            artworkView()
            songInfoView()
            answerCheckView()
        }
    }
    
    @ViewBuilder
    func artworkView() -> some View {
        if let artwork = currentSongList.artwork {
            ArtworkImage(artwork, width: 350)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
    
    func songInfoView() -> some View {
        VStack {
            Text(songData.attributes.name)
                .font(.title)
                .bold()
            Text(songData.attributes.artistName)
                .font(.caption)
        }
    }
    
    func answerCheckView() -> some View {
        VStack {
            Text(isCorrect ? "정답" : "오답")
                .bold()
            NavigationLink {
                if currentIndex < 9 {
                    QuizView(mode: mode, genre: genre, currentSongIndex: $currentIndex)
                } else {
                    
                }
            } label: {
                Text("다음")
                    .asDefaultButtonStyle()
            }
            .simultaneousGesture(TapGesture().onEnded {
                currentIndex += 1
            })
        }
    }
}

