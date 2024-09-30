//
//  SongCheckIntent.swift
//  MusiQ
//
//  Created by 조규연 on 9/30/24.
//

import Foundation

final class SongCheckIntent: SongCheckIntentProtocol {
    private weak var model: SongCheckStateProtocol?
    
    init(model: SongCheckStateProtocol) {
        self.model = model
    }
}

protocol SongCheckIntentProtocol {
    
}
