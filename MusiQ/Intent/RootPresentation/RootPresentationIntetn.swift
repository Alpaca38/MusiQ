//
//  RootPresentationIntetn.swift
//  MusiQ
//
//  Created by 조규연 on 9/23/24.
//

import Foundation

final class RootPresentationIntent {
    private weak var model: RootPresentationActionsProtocol?
    
    init(model: RootPresentationActionsProtocol) {
        self.model = model
    }
}

extension RootPresentationIntent: RootPresentationIntentProtocol {
    func resetView() {
        model?.reset()
    }
}

protocol RootPresentationIntentProtocol {
    func resetView()
}
