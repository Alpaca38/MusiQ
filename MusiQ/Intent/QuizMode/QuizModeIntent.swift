//
//  QuizModeIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/23/24.
//

import Foundation

final class QuizModeIntent: QuizModeIntentProtocol {
    private weak var model: QuizModeActionsProtocol?
    
    init(model: QuizModeActionsProtocol) {
        self.model = model
    }
    
    func selectIndex(_ index: Int) {
        model?.updateCurrentIndex(index)
    }
}

protocol QuizModeIntentProtocol {
    func selectIndex(_ index: Int)
}
