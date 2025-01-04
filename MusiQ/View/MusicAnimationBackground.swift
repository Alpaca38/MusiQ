//
//  MusicAnimationBackground.swift
//  MusiQ
//
//  Created by 조규연 on 1/7/25.
//

import SwiftUI

struct MusicAnimationBackground: View {
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ForEach(0..<20, id: \.self) { index in
                FloatingNote()
                    .offset(x: CGFloat.random(in: -200...200), y: CGFloat.random(in: 0...800)) // 랜덤 위치 배치
                    .opacity(0.8)
                    .scaleEffect(0.5)
            }
        }
    }
}

struct FloatingNote: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        Image(systemName: "music.note")
            .font(.largeTitle)
            .foregroundColor(.white)
            .offset(y: animationOffset)
            .onAppear {
                withAnimation(
                    Animation.linear(duration: Double.random(in: 4...8)) // 랜덤 속도
                        .repeatForever(autoreverses: false)
                ) {
                    animationOffset = -1000 // 위로 떠오르는 애니메이션
                }
            }
    }
}
