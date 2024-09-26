//
//  QuizCategoryView.swift
//  MusiQ
//
//  Created by 조규연 on 9/14/24.
//

import SwiftUI

struct QuizCategoryView: View {
    @StateObject var container: MVIContainer<QuizCategoryIntentProtocol, QuizCategoryStateProtocol>
    private var state: QuizCategoryStateProtocol { container.model }
    private var intent: QuizCategoryIntentProtocol { container.intent }

    var body: some View {
        ScrollView {
            CategoryGridView(state: state, intent: intent)
                .padding()
                .navigationTitle("장르 선택")
        }
        .applyBackground()
    }
}

struct CategoryGridView: View {
    let state: QuizCategoryStateProtocol
    let intent: QuizCategoryIntentProtocol
    
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, content: {
            ForEach(GenreSelection.allCases, id: \.id) { item in
                categoryItem(item)
                    .asButton {
                        intent.categoryTapped(item)
                    }
            }
        })
        .fullScreenCover(item: Binding.constant(state.selectedGenre), content: { genre in
            NavigationLazyView(QuizView(categoryState: state, categoryIntent: intent))
        })
    }
    
    func categoryItem(_ item: GenreSelection) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.random())
                .aspectRatio(1, contentMode: .fit)
            Text(item.genreData.name.localized)
                .font(.custom("CookieRunOTF-Bold", size: 24))
                .foregroundStyle(.text)
        }
    }
}

extension QuizCategoryView {
    static func build(_ mode: Mode) -> some View {
        let model = QuizCategoryModel(mode: mode)
        let intent = QuizCategoryIntent(model: model)
        let container = MVIContainer(intent: intent as QuizCategoryIntentProtocol,
                                     model: model as QuizCategoryStateProtocol,
                                     modelChangePublisher: model.objectWillChange)
        return QuizCategoryView(container: container)
    }
}
//
//#Preview {
//    QuizCategoryView()
//}
