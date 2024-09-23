//
//  QuizModeView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizModeView: View {
    @StateObject var container: MVIContainer<QuizModeIntentProtocol, QuizModeStateProtocol>
    private var state: QuizModeStateProtocol { container.model }
    private var intent: QuizModeIntentProtocol { container.intent }
    
    var body: some View {
        NavigationView {
            CardListView(currentIndex: state.currentIndex,
                         modes: state.modes,
                         onSelect: { index in
                intent.selectIndex(index)
            })
            .navigationTitle("퀴즈 모드 선택")
            .padding(.bottom, 150)
            .applyBackground()
        }
    }
}

struct CardListView: View {
    let currentIndex: Int
    let modes: [Mode]
    let onSelect: (Int) -> Void
    
    var body: some View {
        TabView(selection: Binding(
            get: { currentIndex },
            set: { newIndex in
                onSelect(newIndex)
            }
        )) {
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
            Text(item.localizedName)
                .font(.title)
                .bold()
                .frame(width: 300)
                .foregroundStyle(.white)
        }
    }
}

extension QuizModeView {
    static func build() -> some View {
        let model = QuizModeModel()
        let intent = QuizModeIntent(model: model)
        let container = MVIContainer(intent: intent as QuizModeIntentProtocol,
                                     model: model as QuizModeStateProtocol,
                                     modelChangePublisher: model.objectWillChange)
        return QuizModeView(container: container)
    }
    
}
//#Preview {
//    QuizModeView()
//}
