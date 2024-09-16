//
//  SongCheckView.swift
//  MusiQ
//
//  Created by 조규연 on 9/16/24.
//

import SwiftUI

struct SongCheckView: View {
    let mode: Mode
    let genre: GenreSelection
    let isCorrect: Bool
    let songData: SongData?
    @Binding var currentIndex: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Text(songData?.attributes.name ?? "")
                .font(.title)
                .bold()
            VStack {
                Text(isCorrect ? "정답" : "오답")
                    .bold()
                NavigationLink {
                    QuizView(mode: mode, genre: genre, currentSongIndex: $currentIndex)
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
}

