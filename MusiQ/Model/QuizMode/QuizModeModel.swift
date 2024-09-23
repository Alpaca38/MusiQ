//
//  QuizModeModel.swift
//  MusiQ
//
//  Created by 조규연 on 9/23/24.
//

import Foundation

final class QuizModeModel: ObservableObject, QuizModeStateProtocol {
    @Published var currentIndex: Int = 0
    let modes: [Mode] = Mode.allCases
}

extension QuizModeModel: QuizModeActionsProtocol {
    func updateCurrentIndex(_ index: Int) {
        currentIndex = index
    }
}

protocol QuizModeStateProtocol {
    var currentIndex: Int { get }
    var modes: [Mode] { get }
}

protocol QuizModeActionsProtocol: AnyObject {
    func updateCurrentIndex(_ index: Int)
}
