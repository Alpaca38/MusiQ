//
//  Extension+Color.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1)
        )
    }
}
