//
//  Mode.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

enum Mode: CaseIterable, Hashable {
    case song
    case artwork
    
    var name: String {
        switch self {
        case .song:
            "노래 듣고 맞추기"
        case .artwork:
            "앨범커버 보고 맞추기"
        }
    }
    
    var colors: [Color] {
        switch self {
        case .song:
            [.green, .blue]
        case .artwork:
            [.purple, .red]
        }
    }
    
    var localizedName: String {
        name.localized
    }
}
