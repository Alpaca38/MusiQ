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
            ZStack {
                LinearGradient(
                    colors: [Color.purple, Color.blue],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                cardListView()
                .navigationTitle("퀴즈 모드 선택")
                .padding(.bottom, 150)
                .applyBackground()
            }
        }
    }
    
    func cardListView() -> some View {
        TabView(selection: Binding(
            get: { state.currentIndex },
            set: { newIndex in
                intent.selectIndex(newIndex)
            }
        )) {
            ForEach(state.modes.indices, id: \.self) { index in
                NavigationLink {
                    NavigationLazyView(QuizCategoryView.build(state.modes[index]))
                } label: {
                    cardView(state.modes[index])
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
                .font(.custom("CookieRunOTF-Bold", size: 30))
                .frame(width: 300)
                .foregroundStyle(.text)
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
