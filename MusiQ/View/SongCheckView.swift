//
//  SongCheckView.swift
//  MusiQ
//
//  Created by 조규연 on 9/16/24.
//

import SwiftUI
import MusicKit

struct SongCheckView: View {
    @StateObject var container: MVIContainer<SongCheckIntentProtocol, SongCheckStateProtocol>
    private var state: SongCheckStateProtocol { container.model }
    private var intent: SongCheckIntentProtocol { container.intent }
    
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
        if let artwork = state.currentSongList.artwork {
            ArtworkImage(artwork, width: 350)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
    
    func songInfoView() -> some View {
        VStack {
            Text(state.songData.attributes.name)
                .font(.title)
                .bold()
            Text(state.songData.attributes.artistName)
                .font(.caption)
        }
    }
    
    func answerCheckView() -> some View {
        VStack {
            Text(state.isCorrect ? "정답" : "오답")
                .bold()
            Text(state.currentIndex < 9 ? "다음" : "완료")
                .asButton {
                    if state.currentIndex < 9 {
                        state.categoryIntent.submitAnswer()
                        state.quizIntent.dismiss()
                    } else {
                        rootPresentationIntent.resetView()
                    }
                }
                .asDefaultButtonStyle()
        }
    }
}

extension SongCheckView {
    static func build(mode: Mode, genre: GenreSelection, isCorrect: Bool, songData: SongData, currentSongList: Song, currentIndex: Int, categoryIntent: any QuizCategoryIntentProtocol, quizIntent: QuizIntentProtocol) -> some View {
        let model = SongCheckModel(mode: mode, genre: genre, isCorrect: isCorrect, songData: songData, currentSongList: currentSongList, currentIndex: currentIndex, categoryIntent: categoryIntent, quizIntent: quizIntent)
        let intent = SongCheckIntent(model: model)
        let container = MVIContainer(intent: intent as SongCheckIntentProtocol,
                                     model: model as SongCheckStateProtocol,
                                     modelChangePublisher: model.objectWillChange)
        return SongCheckView(container: container)
    }
}

