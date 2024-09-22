//
//  QuizModeView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizModeView: View {
    @State private var currentIndex = 0
    
    var body: some View {
        NavigationView {
            CardListView(currentIndex: $currentIndex)
                .navigationTitle("퀴즈 모드 선택")
                .padding(.bottom, 150)
                .applyBackground()
        }
    }
}

struct CardListView: View {
    @Binding var currentIndex: Int
    
    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(Mode.allCases.indices, id: \.self) { index in
                NavigationLink {
                    NavigationLazyView(QuizCategoryView(mode: Mode.allCases[index]))
                } label: {
                    cardView(Mode.allCases[index])
                }
            }
        }
        .frame(width: 500, height: 600)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    }
    
    func cardView(_ item: Mode) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(.linearGradient(.init(colors: item.colors), startPoint: .top, endPoint: .bottom))
                .frame(width: 300, height: 400)
            Text(item.name)
                .font(.title)
                .bold()
                .frame(width: 300)
                .foregroundStyle(.white)
        }
    }
}
//#Preview {
//    QuizModeView()
//}
