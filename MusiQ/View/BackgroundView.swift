//
//  BackgroundView.swift
//  MusiQ
//
//  Created by 조규연 on 9/22/24.
//

import SwiftUI

private struct BackgroundView: View {
    var body: some View {
        Color.teal
            .opacity(0.1)
            .ignoresSafeArea()
    }
}

extension View {
    func applyBackground() -> some View {
        ZStack {
            BackgroundView()
            self
        }
    }
}
