//
//  QuizCategoryIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/25/24.
//

import Foundation

final class QuizCategoryIntent: QuizCategoryIntentProtocol {
    private weak var model: QuizCategoryActionsProtocol?
    
    init(model: QuizCategoryActionsProtocol) {
        self.model = model
    }
    
    func categoryTapped(_ genre: GenreSelection) {
        model?.selectGenre(genre)
    }
    
    func submitAnswer() {
        model?.updateCurrentSongIndex()
    }
}

protocol QuizCategoryIntentProtocol {
    func categoryTapped(_ genre: GenreSelection)
    func submitAnswer()
}
