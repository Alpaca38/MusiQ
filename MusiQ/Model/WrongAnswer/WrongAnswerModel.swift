//
//  WrongAnswerModel.swift
//  MusiQ
//
//  Created by 조규연 on 9/30/24.
//

import Foundation
import Combine
import MusicKit
import RealmSwift

final class WrongAnswerModel: ObservableObject, WrongAnswerStateProtocol {
    @ObservedResults(Quiz.self)
    var quizList
    
    @Published var searchText: String = ""
    @Published var musicSubscription: MusicSubscription?
    
    var filteredQuizList: LazyFilterSequence<Results<Quiz>> {
        let filteredList = quizList.filter { [weak self] in
            guard let self else { return false }
            return !$0.isCorrect && (searchText.isEmpty || $0.songName.localizedCaseInsensitiveContains(searchText) || $0.artistName.localizedCaseInsensitiveContains(searchText)) }
        return filteredList
    }
}

extension WrongAnswerModel: WrongAnswerActionsProtocol {
    func updateSearchText(_ text: String) {
        searchText = text
    }
    
    func updateSubscription() async {
        for await subscription in MusicSubscription.subscriptionUpdates {
            musicSubscription = subscription
        }
    }
}

protocol WrongAnswerStateProtocol {
    var quizList: Results<Quiz> { get }
    var searchText: String { get }
    var filteredQuizList: LazyFilterSequence<Results<Quiz>> { get }
    var musicSubscription: MusicSubscription? { get }
}

protocol WrongAnswerActionsProtocol: AnyObject {
    func updateSearchText(_ text: String)
    func updateSubscription() async
}
