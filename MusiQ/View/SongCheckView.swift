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
    let currentIndex: Int
    let categoryIntent: QuizCategoryIntentProtocol
    @Binding var inputSongName: String
    @Binding var inputArtistName: String
    @Environment(\.dismiss) var dismiss
    let quizIntent: QuizIntentProtocol
    
    @EnvironmentObject var rootPresentationContainer: MVIContainer<RootPresentationIntentProtocol, RootPresentationStateProtocol>
    private var rootPresentationState: RootPresentationStateProtocol { rootPresentationContainer.model }
    private var rootPresentationIntent: RootPresentationIntentProtocol { rootPresentationContainer.intent }
    
    var body: some View {
        VStack(spacing: 40) {
            artworkView()
            songInfoView()
            answerCheckView()
        }
        .applyBackground()
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
            Text(currentIndex < 9 ? "다음" : "완료")
                .asButton {
                    if currentIndex < 9 {
                        categoryIntent.submitAnswer()
                        quizIntent.dismiss()
                    } else {
                        rootPresentationIntent.resetView()
                    }
                }
                .asDefaultButtonStyle()
        }
    }
}

