//
//  ButtonWrapper.swift
//  MusiQ
//
//  Created by 조규연 on 9/15/24.
//

import SwiftUI

private struct ButtonWrapper: ViewModifier {
    let action: () -> Void
    func body(content: Content) -> some View {
        Button(action: {
            action()
        }, label: {
            content
        })
    }
}

extension View {
    func asButton(action: @escaping () -> Void) -> some View {
        modifier(ButtonWrapper(action: action))
    }
}