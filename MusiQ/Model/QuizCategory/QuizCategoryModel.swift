//
//  QuizCategoryModel.swift
//  MusiQ
//
//  Created by 조규연 on 9/25/24.
//

import Foundation

final class QuizCategoryModel: ObservableObject, QuizCategoryStateProtocol {
    @Published var currentSongIndex: Int = 0
    @Published var selectedGenre: GenreSelection? = nil
    
    var mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
    }
}

extension QuizCategoryModel: QuizCategoryActionsProtocol {
    func selectGenre(_ genre: GenreSelection) {
        selectedGenre = genre
    }
    
    func updateCurrentSongIndex() {
        currentSongIndex += 1
    }
}

protocol QuizCategoryStateProtocol {
    var currentSongIndex: Int { get }
    var selectedGenre: GenreSelection? { get }
    var mode: Mode { get }
}

protocol QuizCategoryActionsProtocol: AnyObject {
    func selectGenre(_ genre: GenreSelection)
    func updateCurrentSongIndex()
}
