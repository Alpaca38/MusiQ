//
//  QuizModeView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizModeView: View {
    var body: some View {
        NavigationView {
            VStack {
                CardListView()
                    .navigationTitle("퀴즈 모드 선택")
                    .padding(.bottom, 150)
            }
        }
    }
}

struct CardListView: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Mode.allCases, id: \.self) { item in
                        NavigationLink {
                            NavigationLazyView(QuizCategoryView(mode: item))
                        } label: {
                            cardView(item)
                                .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive, axis: .horizontal) { effect, phase in
                                    effect.scaleEffect(1 - abs(phase.value))
                                        .opacity(1 - abs(phase.value))
                                        .rotation3DEffect(.degrees(phase.value * 180), axis: (x: 0, y: 1, z: 0))
                                }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .padding()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
        } else {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Mode.allCases, id: \.self) { item in
                        NavigationLink {
                            NavigationLazyView(QuizCategoryView(mode: item))
                        } label: {
                            cardView(item)
                        }

                    }
                }
            }
            .padding()
            .scrollIndicators(.hidden)
        }
    }
    
    func cardView(_ item: Mode) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.linearGradient(.init(colors: item.colors), startPoint: .top, endPoint: .bottom))
                .frame(width: 200, height: 300)
            Text(item.name)
                .font(.title)
                .bold()
                .frame(width: 200)
                .foregroundStyle(.black)
        }
    }
}

//#Preview {
//    QuizModeView()
//}
