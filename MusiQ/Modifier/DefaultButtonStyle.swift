//
//  DefaultButton.swift
//  MusiQ
//
//  Created by 조규연 on 9/15/24.
//

import SwiftUI

private struct DefaultButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(.indigo)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
}

extension View {
    func asDefaultButtonStyle() -> some View {
        modifier(DefaultButtonStyle())
    }
}
