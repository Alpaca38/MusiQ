//
//  WrongAnswerIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/30/24.
//

import Foundation
import MusicKit

class WrongAnswerIntent: WrongAnswerIntentProtocol {
    private weak var model: WrongAnswerActionsProtocol?
    
    init(model: WrongAnswerActionsProtocol) {
        self.model = model
    }
    
    func updateSearchText(_ text: String) {
        model?.updateSearchText(text)
    }
    
    func playMusic(_ id: String) {
        Task {
            try await MusicKitManager.shared.playMusic(id: MusicItemID(id))
        }
    }
    
    func updateSubscription() async {
        await model?.updateSubscription()
    }
}

protocol WrongAnswerIntentProtocol {
    func updateSearchText(_ text: String)
    func playMusic(_ id: String)
    func updateSubscription() async
}
