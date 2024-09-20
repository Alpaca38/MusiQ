//
//  HeaderStyle.swift
//  MusiQ
//
//  Created by 조규연 on 9/20/24.
//

import SwiftUI

private struct HeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .bold()
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension View {
    func asHeaderStyle() -> some View {
        modifier(HeaderStyle())
    }
}
