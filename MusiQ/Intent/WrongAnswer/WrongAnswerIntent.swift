//
//  WrongAnswerIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/30/24.
//

import Foundation

class WrongAnswerIntent: WrongAnswerIntentProtocol {
    private weak var model: WrongAnswerActionsProtocol?
    
    init(model: WrongAnswerActionsProtocol) {
        self.model = model
    }
    
    func updateSearchText(_ text: String) {
        model?.updateSearchText(text)
    }
}

protocol WrongAnswerIntentProtocol {
    func updateSearchText(_ text: String)
}
